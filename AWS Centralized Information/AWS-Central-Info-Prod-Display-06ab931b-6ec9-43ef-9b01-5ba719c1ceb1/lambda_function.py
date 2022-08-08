import sys
import logging
import rds_config
import pymysql
import json

# rds settings
rds_host  = "rds_link"
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
        "'us-east-2'" : 'AWS-N.Virginia/Ohio',
        "'us-east-1'" : 'AWS-N.Virginia/Ohio',
        "'us-west-1'" : 'AWS-Oregon/N.California',
        "'us-west-2'" : 'AWS-Oregon/N.California',
        "'ap-northeast-1'" : 'AWS-Tokyo',
        "'eu-central-1'" : 'AWS-Frankfurt/Ireland',
        "'eu-west-1'" : 'AWS-Frankfurt/Ireland'
    }


# array to store values to be returned
records = []

# executes upon API event
def lambda_handler(event, context):
    
    # Initialize Default Values for filters
    qsRegion = "'ap-northeast-1'"
    qsRow = "Row"
    qsNumberOfIps = "`'Number Of IPs'`"
    qsEnvironment = "`'Environment'`"
    qsService = "`'Service/Purpose'`"
    qsAccountID = "`'AWS Account ID'`"
    qsVpnID = "`'VPN ID'`"
    qsVpcID = "`'VPC ID'`"
    qsFlowLogID = "`'Flow Log ID'`"
    qsContacPerson = "`'Contact Person'`"
    qsTicket = "`'Ticket'`"
    qsTunnelID = "`'Tunnel ID'`"
    qsIsTGW = "`'TGW Connection'`"
    
    #Get Query String Parameters
    try:
        qsRegion = event['queryStringParameters']['region']
        qsRegion = "'%s'" % qsRegion
    except:
        logger.info("Default Region")
    try:
        qsRow = event['queryStringParameters']['row']
        qsRow = "%s" % qsRow
    except:
        logger.info("Default Row")
    try:
        qsNumberOfIps = event['queryStringParameters']['numberOfIps']
        qsNumberOfIps = "%s" % qsNumberOfIps
    except:
        logger.info("Default Number of IPs")    
    try:
        qsEnvironment = event['queryStringParameters']['environment']
        qsEnvironment = "'%s'" % qsEnvironment
    except:
        logger.info("Default Environment")
    try:
        qsService = event['queryStringParameters']['service']
        qsService = "'%s'" % qsService
    except:
        logger.info("Default service")
    try:
        qsAccountID = event['queryStringParameters']['accountID']
        qsAccountID = "'%s'" % qsAccountID
    except:
        logger.info("Default accountID")
    try:
        qsVpnID = event['queryStringParameters']['vpnID']
        qsVpnID = "'%s'" % qsVpnID
    except:
        logger.info("Default vpnID")
    try:
        qsVpcID = event['queryStringParameters']['vpcID']
        qsVpcID = "'%s'" % qsVpcID
    except:
        logger.info("Default vpcID")
    try:
        qsFlowLogID = event['queryStringParameters']['flowLogID']
        qsFlowLogID = "'%s'" % qsFlowLogID
    except:
        logger.info("Default Flod log ID")
    try:
        qsContacPerson = event['queryStringParameters']['contactPerson']
        qsContacPerson = "'%s'" % qsContacPerson
    except:
        logger.info("Default contact Person")
    try:
        qsTicket = event['queryStringParameters']['ticket']
        qsTicket = "'%s'" % qsTicket
    except:
        logger.info("Default ticket")
    try:
        qsTunnelID = event['queryStringParameters']['tunnelID']
        qsTunnelID = "'%s'" % qsTunnelID
    except:
        logger.info("Default tunnelID")
    try:
        qsIsTGW = event['queryStringParameters']['isTGW']
        qsIsTGW = "'%s'" % qsIsTGW
    except:
        logger.info("Default TGW status")
    
    # Compose SQL Query
    sqlQuery = "SELECT * from `'%s'` " \
               "WHERE " \
               "Row = %s " \
               "AND " \
               "`'Number of IPs'` = %s " \
               "AND " \
               "`'Environment'` = %s " \
               "AND " \
               "`'Service/Purpose'` = %s " \
               "AND " \
               "`'AWS Account ID'` = %s " \
               "AND " \
               "`'VPN ID'` = %s " \
               "AND " \
               "`'VPC ID'` = %s " \
               "AND " \
               "`'Flow Log ID'` = %s " \
               "AND " \
               "`'Contact Person'` = %s " \
               "AND " \
               "`'Ticket'` = %s " \
               "AND " \
               "`'Tunnel ID'` = %s " \
               "AND " \
               "`'TGW Connection'` = %s "  % (Region_Table_dict.get(qsRegion), qsRow, qsNumberOfIps, qsEnvironment, qsService, qsAccountID, qsVpnID, qsVpcID, qsFlowLogID,
               qsContacPerson, qsTicket, qsTunnelID, qsIsTGW)
    print(sqlQuery)
    
    with conn.cursor() as cur:
        #cur.execute("select * from `'%s'`" % (Region_Table_dict.get(qsRegion)))
        cur.execute(sqlQuery)
        conn.commit()
    
    del records[:]
    
    for col in cur:
        record = {
            'col': col[0],
            'col_Details': {
                'Network': col[1],
                'Netmask': col[2],
                'CIDR': col[3],
                'NumberOfIPs': col[4],
                'NetworkIpRange': col[5],
                'SubnetBroadcast': col[6],
                'TunnelIP1': col[7],
                'TunnelIP2': col[8],
                'Environment': col[9],
                'Service': col[10],
                'Description': col[11],
                'AccountID': col[12],
                'VPNID': col[13],
                'VPCID': col[14],
                'FlowLogID': col[15],
                'PlanEndSchedule': col[16],
                'DateOfCreation': col[17],
                'ContactPerson': col[18],
                'Ticket': col[19],
                'TunnelID': col[20],
                'TGWConnection': col[21]
            }
        }
        records.append(record)
    
    responseObject = {}
    responseObject.clear()
    responseObject['statusCode'] = 200
    responseObject['headers'] = {}
    responseObject['headers']['Content-Type'] = 'application/json'
    responseObject['body'] = json.dumps(records)
        
    return responseObject
