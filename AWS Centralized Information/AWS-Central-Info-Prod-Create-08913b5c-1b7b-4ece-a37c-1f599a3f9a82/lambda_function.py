#Created By Keith Benedicto, COC JP Q4 2019
import sys
import logging
import rds_config
import pymysql
import json
import pyipcalc

# rds settings
rds_host  = "aws-centralized-infodb.c0mpehgheiga.us-west-2.rds.amazonaws.com"
name = rds_config.db_username
password = rds_config.db_password
db_name = rds_config.db_name
# logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)
# connect using creds from rds_config.py
try:
    conn = pymysql.connect(rds_host, user=name, passwd=password, db=db_name, connect_timeout=5)
except:
    logger.info("ERROR: Unexpected error: Could not connect to MySql instance.")
    sys.exit()
logger.error("SUCCESS: Connection to RDS mysql instance succeeded")
# Create Region Dictionary based on the DB Tables
Region_Table_dict = {
        "us-east-2" : 'AWS-N.Virginia/Ohio',
        "us-east-1" : 'AWS-N.Virginia/Ohio',
        "us-west-1" : 'AWS-Oregon/N.California',
        "us-west-2" : 'AWS-Oregon/N.California',
        "ap-northeast-1" : 'AWS-Tokyo',
        "eu-central-1" : 'AWS-Frankfurt/Ireland',
        "eu-west-1" : 'AWS-Frankfurt/Ireland'
    }
Field_Table_dict = {
        "numIps": "`'Number of IPs'`",
        "network":"`'Network'`",
        "netmask":"`'Netmask'`",
        "cidr":"`'CIDR'`",
        "IPrange":"`'Network IP Range'`",
        "broadcastIP":"`'Subnet Broadcast'`",
        "environment" : "`'Environment'`",          
        "service" : "`'Service/Purpose'`",
        "accountID" : "`'AWS Account ID'`",
        "tunnelIP1": "`'Tunnel IP 1'`",
        "tunnelIP2": "`'Tunnel IP 2'`",
        "description": "`'Description'`",
        "vpnID": "`'VPN ID'`",
        "vpcID":"`'VPC ID'`",
        "flowLogID":"`'Flow Log ID'`",
        "endSchedule":"`'Plan End Schedule'`",
        "creationDate":"`'Date of Creation'`",
        "contactPerson":"`'Contact Person'`",
        "ticket":"`'Ticket'`",
        "tunnelID": "`'Tunnel ID'`",
        "tgw":"`'TGW Connection'`"
    }
#LISTS OF REGIONS AND HOSTS WITH THEIR COUNTERPARTS
regions = ["ap-northeast-1","us-west-1","us-west-2","us-east-1","us-east-2","eu-central-1","eu-west-1"]
ipx = ['102','106','106','107','107','102','102']

#FOR SUBNET
subn = ['30','29','28','27','26','25','24','23','22','21','20','19']
hosts = ['4','8','16','32','64','128','256','512','1024','2048','4096','8192']

def special_alloc(region,ip_octet,z,y):
    inside_network = '10.' + '%s.' %str(ip_octet) + '%s.'%z + '%s' %y
    inside_cidr = inside_network + '/24'
    special_net = pyipcalc.IPNetwork(inside_cidr)
    special_range = special_net.first() + ' to ' + special_net.last()
    with conn.cursor() as cur:
        query = "INSERT INTO `%s` (`'Number of IPs'`,`'Network'`,`'Netmask'`,`'CIDR'`,`'Network IP Range'`,`'Subnet Broadcast'`,`'Environment'`,`'Service/Purpose'`,`'AWS Account ID'`,`'Description'`,`'Contact Person'`,`'Ticket'`,`'VPN ID'`,`'VPC ID'`, `'Flow Log ID'`,`'Plan End Schedule'`,`'Tunnel ID'`,`'TGW Connection'`,`'Date of Creation'`) VALUES ('256',%s,%s,%s,%s,%s,'FREE','FREE','FREE','FREE','FREE','FREE','','','','','','','')"
        cur.execute(query,(Region_Table_dict.get(region),str(inside_network),special_net.mask(),str(special_net),special_range,special_net.broadcast()))
        conn.commit()
    return(ip_octet,z,y)

def update_query(region,aws_info,tempInfo,values,second_net,mask,second_network,ip_range2,broad):
    aws_info.update({"network": "%s" %second_net , "netmask": "%s" %mask, "cidr": "%s" %second_network,"IPrange": "%s" %ip_range2,"broadcastIP": "%s" %broad})
    fields = aws_info.keys()
    for val in aws_info.values():
        tempInfo.append(val)
    for key in aws_info.keys():
        values.append(Field_Table_dict.get(key))
    query = "INSERT INTO `'%s'` " %(Region_Table_dict.get(region))  
    isFirstField = 1
    for field in fields:
            if isFirstField == 1:
                query+= "(%s" %values[0]
                isFirstField = 0
                x = len(values)
                i = 1
            else:
                while i < x:
                    query+=",%s" %values[i]
                    i+=1
    query+=") VALUES ("   
    for x in aws_info.values():
        iterator = ""
        query+="'%s'" %tempInfo[0]
        iterator = 2
        x = len(tempInfo)
        i = 1
        while i < x:
            query+=",'%s'" %tempInfo[i]
            i+=1
        break
    query+=")" 
    with conn.cursor() as cur:
        cur.execute(query)
        conn.commit()

def lambda_handler(event, context):
    pd = event
    query,network = "",""
    tempInfo,values = [],[]
    complete = 0
    for key in pd.keys():
        region = key
        parsed_ip = pd[region]['numIps']
#PARSE REGION/NUM OF IPS FROM JSON AND COMPUTE FOR IP
        if region in regions:
            index_reg = regions.index(region)
            ip_octet = ipx[index_reg]
        else:
            return('ERROR: Invalid Region')
        if parsed_ip in hosts:
            index = hosts.index(parsed_ip)
            sub = subn[index]
        else:
            return('ERROR: Invalid Network')
# SEE IF THERE IS A FREE NETWORK THAT CAN BE USED 
        with conn.cursor() as cur:
            free_checker = "SELECT * FROM `%s` WHERE `'Number of IPs'` = %s AND `'Environment'` = 'FREE' AND `'Description'` = 'FREE' ORDER BY `Row` DESC LIMIT 1"
            cur.execute(free_checker,(Region_Table_dict.get(region),parsed_ip))
            free_net = cur.fetchall()
            if free_net == ():
                print('No Free IP that can be used')
# UPDATING THE LAST FIELD THAT IS FREE AND MATCHES CRITERIA             
            else:
                fields = pd[region].keys()
                isFirstField = 1
                query = "UPDATE `'%s'` " % (Region_Table_dict.get(region))
                for field in fields:
                    if isFirstField == 1:
                        query += "SET %s='%s'" % (Field_Table_dict.get(field), pd[region][field])
                        isFirstField = 0
                    else:
                        query += ", %s='%s'" % (Field_Table_dict.get(field), pd[region][field])
                query += " WHERE Row = '%s'" % (free_net[0][0])
                with conn.cursor() as cur:
                    cur.execute(query)
                    conn.commit()
                complete = 1
            if complete == 1:
                return ('Done! Used free IP: See your IP in Row %s' %free_net[0][0])
            else:
#LAST BROADCAST FROM MYSQL
                check_last = "SELECT * FROM `%s` ORDER BY `Row` DESC LIMIT 1 "
                cur.execute(check_last,(Region_Table_dict.get(region)))
                conn.commit()
                last_broadcast =  cur.fetchall()[0][6]
# #SPLITTING IP TO CREATE FREE IPS DEPENDING ON THE LAST BROADCAST IP
                data = last_broadcast.split('.')
                if data[3] == '255':
                    z = int(data[2]) + 1
                    y = '0'
#IF BROADCAST ADDRESS OF LAST ENDS IN 127 OR 63 OR 191         
                elif data[3] == '127' or '63' or '191':
#IF IT ENDS IN 127, IT WILL CREATE ANOTHER NETWORK WITH 128 HOSTS AND TAG IT AS FREE          
                    if data [3] == '127':
                        second_network = data[0] + '.%s.' %data[1] + '%s.' %data[2] + '%s/25' %str(int(data[3]) + 1)
                        second_net = data[0] + '.%s.' %data[1] + '%s.' %data[2] + '%s' %str(int(data[3]) + 1)
                        net2 = pyipcalc.IPNetwork(second_network)
                        mask = str(net2.mask())
                        broad = net2.broadcast()
                        ip_range2 = net2.first() + ' to ' + net2.last()
                        ip_set = 1
# IF LAST BROADCAST[3] = 127 AND NEEDED IP = 128, ALLOCATE 128 IP
                        if parsed_ip == '128':
                            aws_info = pd[region]  
                            with conn.cursor() as cur: 
                                update_query(region,aws_info,tempInfo,values,second_net,mask,second_network,ip_range2,broad) 
                                alloc = "SELECT * FROM `%s` ORDER BY `Row` DESC LIMIT 1"
                                cur.execute(alloc,(Region_Table_dict.get(region)))
                                last_row = cur.fetchall()
                                return ('Done! Please see your IP in Row %s' %last_row[0][0])
# IF LAST BROADCAST[3] = 127 AND NEEDED IP = 64, ALLOCATE 64 IP
                        elif parsed_ip == '64':
                            second_network = data[0] + '.%s.' %data[1] + '%s.' %data[2] + '%s/26' %str(int(data[3]) + 1)
                            second_net = data[0] + '.%s.' %data[1] + '%s.' %data[2] + '%s' %str(int(data[3]) + 1)
                            net2 = pyipcalc.IPNetwork(second_network)
                            mask = str(net2.mask())
                            broad = net2.broadcast()
                            ip_range2 = net2.first() + ' to ' + net2.last()
                            aws_info = pd[region]
                            update_query(region,aws_info,tempInfo,values,second_net,mask,second_network,ip_range2,broad)
                            return ('Done! Please see your IP in Row %s' %return_last_row)
                                # alloc = "SELECT * FROM `%s` ORDER BY `Row` DESC LIMIT 1"
                                # cur.execute(alloc,(Region_Table_dict.get(region)))
                                # last_row = cur.fetchall()

                    else:
# BROADCAST IS EITHER 63 OR 191
                        second_network = data[0] + '.%s.' %data[1] + '%s.' %data[2] + '%s/26' %str(int(data[3]) + 1) 
                        second_net = data[0] + '.%s.' %data[1] + '%s.' %data[2] + '%s' %str(int(data[3]) + 1)
                        net2 = pyipcalc.IPNetwork(second_network)
                        ip_range2 = net2.first() + ' to ' + net2.last()
                        ip_set = 2
                        if parsed_ip == '128':
                            with conn.cursor() as cur:
                                queries = ['64','128']
                                for x in queries:
                                    if x == '64':
                                        query1 = "INSERT INTO `%s` (`'Number of IPs'`,`'Network'`,`'Netmask'`,`'CIDR'`,`'Network IP Range'`,`'Subnet Broadcast'`,`'Environment'`,`'Service/Purpose'`,`'AWS Account ID'`,`'Description'`,`'Contact Person'`,`'Ticket'`) VALUES (%s,%s,%s,%s,%s,%s,'FREE','FREE','FREE','FREE','FREE','FREE')"         
                                        cur.execute(query1,(Region_Table_dict.get(region),x,second_net,str(net2.mask()),second_network,ip_range2,net2.broadcast()))
                                        conn.commit()
                                    else:
                                        check_last = "SELECT * FROM `%s` ORDER BY `Row` DESC LIMIT 1 "
                                        cur.execute(check_last,(Region_Table_dict.get(region)))
                                        conn.commit()
                                        last_broadcast =  cur.fetchall()[0][6]
                                        data = last_broadcast.split('.')
                                        if data[3] == '255':
                                            second_network = data[0] + '.%s.' %data[1] + '%s.' %str(int(data[2]) + 1) + '0/25'
                                            second_net = data[0] + '.%s.' %data[1] + '%s.' %str(int(data[2]) + 1) + '0'
                                            net2 = pyipcalc.IPNetwork(second_network)
                                            mask = str(net2.mask())
                                            broad = net2.broadcast()
                                            ip_range2 = net2.first() + ' to ' + net2.last()
                                            aws_info = pd[region] 
                                            with conn.cursor() as cur:
                                                update_query(region,aws_info,tempInfo,values,second_net,mask,second_network,ip_range2,broad)
                                                alloc = "SELECT * FROM `%s` ORDER BY `Row` DESC LIMIT 1"
                                                cur.execute(alloc,(Region_Table_dict.get(region)))
                                                last_row = cur.fetchall()
                                                return ('Done! Please see your IP in Row %s' %last_row[0][0])
                                        else:
                                            aws_info = pd[region]
                                            with conn.cursor() as cur:
                                                update_query(region,aws_info,tempInfo,values,second_net,mask,second_network,ip_range2,broad)
                                                alloc = "SELECT * FROM `%s` ORDER BY `Row` DESC LIMIT 1"
                                                cur.execute(alloc,(Region_Table_dict.get(region)))
                                                last_row = cur.fetchall()
                                                return ('Done! Please see your IP in Row %s' %last_row[0][0])
                                    second_network = data[0] + '.%s.' %data[1] + '%s.' %data[2] + '128/25'
                                    second_net = data[0] + '.%s.' %data[1] + '%s.' %data[2] + '128'
                                    net2 = pyipcalc.IPNetwork(second_network)
                                    ip_range2 = net2.first() + ' to ' + net2.last()
                        elif parsed_ip == '64':
                            second_network = data[0] + '.%s.' %data[1] + '%s.' %data[2] + '%s/26' %str(int(data[3]) + 1)
                            second_net = data[0] + '.%s.' %data[1] + '%s.' %data[2] + '%s' %str(int(data[3]) + 1)
                            net2 = pyipcalc.IPNetwork(second_network)
                            mask = str(net2.mask())
                            broad = net2.broadcast()
                            ip_range2 = net2.first() + ' to ' + net2.last()
                            aws_info = pd[region]
                            with conn.cursor() as cur:
                                update_query(region,aws_info,tempInfo,values,second_net,mask,second_network,ip_range2,broad)
                                alloc = "SELECT * FROM `%s` ORDER BY `Row` DESC LIMIT 1"
                                cur.execute(alloc,(Region_Table_dict.get(region)))
                                last_row = cur.fetchall()
                                return ('Done! Please see your IP in Row %s' %last_row[0][0])                   
                    second_net = data[0] + '.%s.' %data[1] + '%s.' %data[2] + '%s' %str(int(data[3]) + 1)
                    net2 = pyipcalc.IPNetwork(second_network)
                    ip_range2 = net2.first() + ' to ' + net2.last()
                    data2 = net2.broadcast().split('.')
                    z = int(data[2]) + 1
                    y = '0'
                    if ip_set == 1:
                        jot = '128'
                    else:
                        jot = '64'
                    with conn.cursor() as cur:
                        query1 = "INSERT INTO `%s` (`'Number of IPs'`,`'Network'`,`'Netmask'`,`'CIDR'`,`'Network IP Range'`,`'Subnet Broadcast'`,`'Environment'`,`'Service/Purpose'`,`'AWS Account ID'`,`'Description'`,`'Contact Person'`,`'Ticket'`) VALUES (%s,%s,%s,%s,%s,%s,'FREE','FREE','FREE','FREE','FREE','FREE')"         
                        cur.execute(query1,(Region_Table_dict.get(region),jot,second_net,str(net2.mask()),second_network,ip_range2,net2.broadcast()))
                        conn.commit()
#IF IT ENDS IN 63, IT WILL CREATE 2 NETWORKS, 1 WITH 63 HOSTS AND 1 WITH 128 HOSTS ALL FREE
                    if data2[3] == '127':
                        third_network = data2[0] + '.%s.' %data2[1] + '%s.' %data2[2] + '%s/25' %str(int(data2[3]) + 1)
                        third_net = data2[0] + '.%s.' %data2[1] + '%s.' %data2[2] + '%s' %str(int(data2[3]) + 1)
                        net3 = pyipcalc.IPNetwork(third_network)
                        ip_range3 = net3.first() + ' to ' + net3.last()
                        with conn.cursor() as cur:
                            query2 = "INSERT INTO `%s` (`'Number of IPs'`,`'Network'`,`'Netmask'`,`'CIDR'`,`'Network IP Range'`,`'Subnet Broadcast'`,`'Environment'`,`'Service/Purpose'`,`'AWS Account ID'`,`'Description'`,`'Contact Person'`,`'Ticket'`) VALUES ('128',%s,%s,%s,%s,%s,'FREE','FREE','FREE','FREE','FREE','FREE')"
                            cur.execute(query2,(Region_Table_dict.get(region),third_net,net3.mask(),third_network,ip_range3,net3.broadcast()))
                            conn.commit()
#SPECIAL CONDITIONS IF IPS ARE 512, 1024 OR 2048. FOR 4096, HAVEN'T INCLUDED IT YET SINCE NO REQUEST YET FOR 4096 IS PRESENT
                if parsed_ip == '512':
                    if int(z) % 2 != 0:
                        while int(z) % 2 != 0:
                            ip_octet,z,y = special_alloc(region,ip_octet,z,y)
                            z +=1
                elif parsed_ip == '1024':
                    if int(z) % 4 != 0:
                        while int(z) % 4 != 0:
                            ip_octet,z,y = special_alloc(region,ip_octet,z,y)
                            z +=1
                elif parsed_ip == '2048':
                    if int(z) % 8 != 0:
                        while int(z) % 8 != 0:
                            ip_octet,z,y = special_alloc(region,ip_octet,z,y)
                            z +=1
                elif parsed_ip == '4096':
                    if int(z) % 16 != 0:
                        while int(z) % 16 != 0:
                            ip_octet,z,y = special_alloc(region,ip_octet,z,y)
                            z +=1
                elif parsed_ip == '8192':
                    if int(z) % 32 != 0:
                        while int(z) % 32 != 0:
                            ip_octet,z,y = special_alloc(region,ip_octet,z,y)
                            z +=1
#NEW IP SEGMENT TO BE USED FOR ASSIGNMENT 
                new_network = '10.' + '%s.' %str(ip_octet) + '%s.'%z + '%s' %y
                network = new_network + '/%s' %str(sub)
                net = pyipcalc.IPNetwork(network)
                broad = net.broadcast()
                mask = net.mask()
                ip_range = net.first() + ' to ' + net.last()
#DONE AND READY TO UPDATE IN MYSQL
                pd[region].update({"network": "%s" %new_network  , "netmask": "%s" %mask, "cidr": "%s" %net,"IPrange": "%s" %ip_range,"broadcastIP": "%s" %broad})
                fields = pd[region].keys()
                for val in pd[region].values():
                    tempInfo.append(val)
                for key in pd[region].keys():
                    values.append(Field_Table_dict.get(key))
                query = "INSERT INTO `'%s'` " %(Region_Table_dict.get(region))  
                isFirstField = 1
                for field in fields:
                        if isFirstField == 1:
                            query+= "(%s" %values[0]
                            isFirstField = 0
                            x = len(values)
                            i = 1
                        else:
                            while i < x:
                                query+=",%s" %values[i]
                                i+=1
                query+=") VALUES ("   
                for x in pd[region].values():
                    iterator = ""
                    query+="'%s'" %tempInfo[0]
                    iterator = 2
                    x = len(tempInfo)
                    i = 1
                    while i < x:
                        query+=",'%s'" %tempInfo[i]
                        i+=1
                    break
                query+=")"   
                with conn.cursor() as cur:
                    cur.execute(query)
                    conn.commit()
                    alloc = "SELECT * FROM `%s` ORDER BY `Row` DESC LIMIT 1"
                    cur.execute(alloc,(Region_Table_dict.get(region)))
                    last_row = cur.fetchall()
                    return ('Done! Please see your IP in Row %s' %last_row[0][0])



