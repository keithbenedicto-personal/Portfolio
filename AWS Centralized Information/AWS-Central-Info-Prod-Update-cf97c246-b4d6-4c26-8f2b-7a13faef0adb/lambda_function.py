import sys
import logging
import rds_config
import pymysql
import json

# rds settings
rds_host = "rds_link"
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
    "us-east-2": 'AWS-N.Virginia/Ohio',
    "us-east-1": 'AWS-N.Virginia/Ohio',
    "us-west-1": 'AWS-Oregon/N.California',
    "us-west-2": 'AWS-Oregon/N.California',
    "ap-northeast-1": 'AWS-Tokyo',
    "eu-central-1": 'AWS-Frankfurt/Ireland',
    "eu-west-1": 'AWS-Frankfurt/Ireland'
}

Field_Table_dict = {
    "numIps": "`'Number of IPs'`",
    "environment": "`'Environment'`",
    "service": "`'Service/Purpose'`",
    "accountID": "`'AWS Account ID'`",
    "tunnelIP1": "`'Tunnel IP 1'`",
    "tunnelIP2": "`'Tunnel IP 2'`",
    "description": "`'Description'`",
    "vpnID": "`'VPN ID'`",  # Causing fucking issue
    "vpcID": "`'VPC ID'`",  # Causing issue
    "flowLogID": "`'Flow Log ID'`",
    "endSchedule": "`'Plan End Schedule'`",
    "creationDate": "`'Date of Creation'`",  # To be reviewed since we can get local time through python library
    "contactPerson": "`'Contact Person'`",
    "ticket": "`'Ticket'`",
    "tunnelID": "`'Tunnel ID'`",
    "tgw": "`'TGW Connection'`"

}


def lambda_handler(event, context):
    # transactionId = event['queryStringParameters']['transactionId']
    pd = event
    query = ""
    for key in pd.keys():
        region = key
        test = pd[region]
        print(test)
        print(region)
        for row in test.keys():
            print(test.keys())
            row = row
            print(row)

        fields = pd[region][row].keys()
        isFirstField = 1
        print(fields)

        # Compose sql
        # UPDATE Claude
        query = "UPDATE `'%s'` " % (Region_Table_dict.get(region))
        # SET Clause
        # iterate through fields to update
        for field in fields:
            # check if it is the first field to update
            if isFirstField == 1:
                query += "SET %s='%s'" % (Field_Table_dict.get(field), pd[region][row][field])
                isFirstField = 0
            else:
                query += ", %s='%s'" % (Field_Table_dict.get(field), pd[region][row][field])

    # IMPORTANT WHERE Clause
    query += " WHERE Row = '%s'" % (row)
    print(query)
    with conn.cursor() as cur:
        # cur.execute("select * from `'%s'`" % (Region_Table_dict.get(qsRegion)))
        cur.execute(query)
        conn.commit()

    # region = pd.keys()

    # transactionResponse = {}
    # transactionResponse['transactionId'] = transactionId
    # transactionResponse['message'] = 'transaction ID is: ' + transactionId

    responseObject = {}
    responseObject['statusCode'] = 200
    responseObject['headers'] = {}
    responseObject['headers']['Content-Type'] = 'application/json'
    # responseObject['body'] = json.dumps(transactionResponse)

    return json.dumps(responseObject)
