import subprocess
import logging
import sys
import boto3
import ast

logging.basicConfig(filename=f'upstream_servers_{sys.argv[1]}.log', format='%(asctime)s - %(levelname)s - %(message)s')
tenant_status_inactive = ['NEW','DELETED','ERROR'] # treats the ff. statuses as INACTIVE
new_nodes = []
dynamodb_keys = []
cluster_status = {}
dynamo_client = boto3.client("dynamodb", region_name=sys.argv[4])
table = sys.argv[2]

def nginx_nodes():
    try:
        all_nodes = "sudo /root/bin/kubectl get nodes -o jsonpath='{range .items[*]}{.metadata.name}{\"\\n\"}{end}'"
        nodes = subprocess.check_output(all_nodes, shell=True).decode().strip().split("\n")
        with open(f'/etc/nginx/upstream_servers_{sys.argv[1]}.txt', 'r') as server_list:
            servers = server_list.read().splitlines()
        for node in nodes:
            pod_selector = f"sudo /root/bin/kubectl get pods --all-namespaces --field-selector spec.nodeName={node}"
            pod = subprocess.check_output(pod_selector + " -o jsonpath='{range .items[*]}{.metadata.name}{\"\\n\"}{end}'", shell=True).decode().strip().split("\n")
            if any(f'{sys.argv[1]}' in values for values in pod):
                new_nodes.append(node)
            else:
                print(f"CONFIG_CHECKER: {sys.argv[1]} pod does not exist on node {node}")
        if servers == [str(instance) for instance in new_nodes]:
            print(f'CONFIG_CHECKER: Upstream nodes for {sys.argv[1]} match')
        else:
            logging.info(f'CONFIG_CHECKER: Upstream nodes for {sys.argv[1]} does not match its previous list')
            command = ["python3", "/etc/nginx/config_generator.py", sys.argv[1], sys.argv[2], sys.argv[3]]
            subprocess.run(command, capture_output=True, text=True)
            restart = ["systemctl", "restart", "nginx"]
            subprocess.run(restart, capture_output=True, text=True)
    except Exception as err:
        logging.error(err)

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

if __name__ == "__main__":
    nginx_nodes()
    cluster_keys()
    dynamo_runner()
    print(cluster_status)
    with open('/etc/nginx/active_cluster.txt', 'r') as current_cluster:
        cluster = current_cluster.read()
        try:
            if ast.literal_eval(cluster) == cluster_status:
                print("SAME ACTIVE CLUSTER EXISTS")
            else:
                logging.info(f'ACTIVE CLUSTER CHANGED')
                command = ["python3", "/etc/nginx/config_generator.py", sys.argv[1], sys.argv[2], sys.argv[3]]
                subprocess.run(command, capture_output=True, text=True)
                restart = ["systemctl", "restart", "nginx"]
                subprocess.run(restart, capture_output=True, text=True)
        except subprocess.CalledProcessError as err: 
            logging.error('Invalid JSON Format: ', err)