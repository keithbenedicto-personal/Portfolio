import subprocess
import os
import shutil
import json
import sys
import logging
import boto3

nginx_conf_file = '/etc/nginx/nginx.conf'
nginx_conf_backup_file = f'/etc/nginx/nginx_{sys.argv[1]}.conf.bak'
nginx_upstream_server_file = f'/etc/nginx/upstream_servers_{sys.argv[1]}.txt'
nginx_active_cluster = '/etc/nginx/active_cluster.txt'
logging.basicConfig(filename=f'upstream_servers_{sys.argv[1]}.log', level=logging.DEBUG, format='%(asctime)s - %(levelname)s - %(message)s')
dynamodb_keys = []
cluster_status = {}
port_mapping = {}
tenant_status_inactive = ['NEW','DELETED','ERROR'] # treats the ff. statuses as INACTIVE
dynamo_client = boto3.client("dynamodb", region_name=sys.argv[4])
table = sys.argv[2]

def cluster_keys(): # Transform the coreid
    id = sys.argv[3]
    response = dynamo_client.scan(
        TableName=table,
        FilterExpression='id = :value',
        ExpressionAttributeValues= {
            ':value': {
                'S': id
            }
        }
    )
    for item in response['Items']:
        item_name = item['item_name']['S']
    dynamodb_keys.append(item_name)
    if 'GREEN' in item_name:
        dynamodb_keys.append(item_name.replace('GREEN', 'BLUE'))
    else:
        dynamodb_keys.append(item_name.replace('BLUE', 'GREEN'))

def dynamo_runner(): # Query DynamoDB to get which is the active and inactive cluster
    for key in dynamodb_keys:
        response = dynamo_client.query(
            TableName=table,
            KeyConditionExpression='item_name = :value',
            ExpressionAttributeValues= {
                ':value': {'S': key}
            }
        )
        if not response['Items']:
            cluster_status.update({'NONE_EXISTING_GREEN_ENVIRONMENT':'INACTIVE'}) # appends INACTIVE to GREEN Environment for initial deployments
        else:
            for item in response['Items']:
                if item['tenant_status']['S'] in tenant_status_inactive:
                    cluster_status.update({item['id']['S']:'INACTIVE'}) # Treats tenants with INPROGRESS status as INACTIVE
                else:
                    cluster_status.update({item['id']['S']:item['tenant_status']['S']})

    print(cluster_status)
    return True if all(value == 'ACTIVE' for value in cluster_status.values()) else next((key for key, value in cluster_status.items() if value == 'ACTIVE'), False)

def pod_selector():
    try: # Get service details based on POD type
        raw_data = f'sudo /root/bin/kubectl get services/nginx-{sys.argv[1]}-nginx -n nginx -o json'
        parsed_data = subprocess.check_output(raw_data, shell=True).decode()
        parsed_json = json.loads(parsed_data)
        for port in parsed_json['spec']['ports']:
            port_mapping[port['port']] = port['nodePort']
    except Exception as err:
        logging.error('CONFIG_GENERATOR: kubectl error: ', err)
        sys.exit()

    # Generate a list of all available nodes to be used by the NGINX conf file
    raw_ports = "sudo /root/bin/kubectl get nodes -o jsonpath='{range .items[*]}{.status.addresses[?(@.type==\"InternalIP\")].address}{\"\\n\"}{end}'"
    upstream_servers = subprocess.check_output(raw_ports, shell=True).decode().strip().split("\n")

    # Generate file for upstream servers depending on the pod type
    all_nodes = "sudo /root/bin/kubectl get nodes -o jsonpath='{range .items[*]}{.metadata.name}{\"\\n\"}{end}'"
    nodes = subprocess.check_output(all_nodes, shell=True).decode().strip().split("\n")
    with open(nginx_upstream_server_file, 'w+') as server_list:
        for node in nodes:
            pod_selector = f"sudo /root/bin/kubectl get pods --all-namespaces --field-selector spec.nodeName={node}"
            pod = subprocess.check_output(pod_selector + " -o jsonpath='{range .items[*]}{.metadata.name}{\"\\n\"}{end}'", shell=True).decode().strip().split("\n")
            if any(f'{sys.argv[1]}' in values for values in pod):
                server_list.write(str(node) + '\n')
                logging.info(f"CONFIG_GENERATOR: {sys.argv[1]} pod exists on node {node}")
            else:
                logging.info(f"CONFIG_GENERATOR: {sys.argv[1]} pod does not exist node {node}")

    # Backing up old configuration file
    if os.path.exists(nginx_conf_file):
        try:
            shutil.copyfile(nginx_conf_file, nginx_conf_backup_file)
            logging.info(f"CONFIG_GENERATOR: Backed up {nginx_conf_file} to {nginx_conf_backup_file}")
        except Exception as error:
            logging.error('CONFIG_GENERATOR: File backup error: ', error)
    else:
        logging.info(f"CONFIG_GENERATOR: {nginx_conf_file} does not exist. Creating a new configuration file.")

    # Generating new nginx.conf file
    with open(nginx_conf_file, 'w+') as f:
        f.write('# ELB backend configuration\n\n')
        f.write('user nginx;\n')
        f.write('worker_processes auto;\n')
        f.write('error_log /var/log/nginx/tcp_errors.log notice;\n')
        f.write('pid /run/nginx.pid;\n')
        f.write('include /usr/share/nginx/modules/*.conf;\n')
        f.write('events {\n')
        f.write('       worker_connections 1024;\n')
        f.write('}\n')
        f.write('\nhttp {\n')
        f.write('   server {\n')
        f.write('       listen 8999 default_server;\n')
        f.write('       listen [::]:8999 default_server;\n')
        f.write('       server_name _;\n')
        f.write('       root /usr/share/nginx/html;\n')
        f.write('       include /etc/nginx/default.d/*.conf;\n')
        f.write('       location / { \n')
        f.write('       }\n')
        f.write('       location /nginx_status {\n')
        f.write('       stub_status;\n')
        f.write('       allow 127.0.0.1;\n')
        f.write('       deny all;\n')
        f.write('           }\n')
        f.write('       }\n')
        f.write('}\n')
        f.write('\n# Upstream server configuration\n')
        f.write('stream {\n')
        for lb_port in port_mapping.values():
            f.write(f"  upstream backend_{lb_port}")
            f.write(' {\n')
            f.write(f"    zone backend_{lb_port} 64k;\n")
            for nodes in upstream_servers:
                f.write(f"    server {nodes}:{lb_port};\n")
            f.write('  }\n')
        for lb_port, instance_port in port_mapping.items():
            f.write('  server {\n')
            f.write(f"    listen {lb_port};\n")
            f.write(f"    proxy_pass backend_{instance_port};\n")
            f.write('    tcp_nodelay on;\n')
            f.write('    proxy_connect_timeout 1s;\n')
            f.write('    proxy_timeout 60s;\n')
            f.write('    error_log /var/log/nginx/tcp_errors.log error;\n')
            f.write('  }\n\n')
        f.write('}\n')

if __name__ == "__main__":
    cluster_keys()
    cluster_details = dynamo_runner()
    if cluster_details == True:
        logging.error('Both clusters are marked as ACTIVE')
    elif cluster_details == False:
        logging.error('Both clusters are marked as INACTIVE')
    else:
        command = ["sudo", "aws", "eks", "--region", sys.argv[4], "update-kubeconfig", "--name", "dma-{}".format(cluster_details)]
        print(command)
        subprocess.run(command, capture_output=True, text=True)
        pod_selector()
        with open(nginx_active_cluster, 'w+') as cluster_details:
            cluster_details.write(str(cluster_status) + '\n')
        print('NGINX config file created!')