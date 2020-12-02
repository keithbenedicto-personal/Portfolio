# Created By Keith Benedicto, COC JP Q4 2019
# Updated by AWS Central Information Team, Lead Joel Nidoy


import logging
import rds_config
import pymysql
from functools import wraps
import ipaddress
import math

# from jira import JIRA


# logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

# Region table and network mapping
REGIONS_MAPPING = {
    "us-east-2": {
        "table_name": "AWS-N.Virginia/Ohio",
        "network": ["10.107.0.0/16", "10.154.0.0/16"]
    },
    "us-east-1": {
        "table_name": "AWS-N.Virginia/Ohio",
        "network": ["10.107.0.0/16", "10.154.0.0/16"]
    },
    "us-west-1": {
        "table_name": "AWS-Oregon/N.California",
        "network": ["10.104.0.0/15", "10.152.0.0/16"]
    },
    "us-west-2": {
        "table_name": "AWS-Oregon/N.California",
        "network": ["10.106.0.0/16", "10.152.0.0/16"]
    },
    "ap-northeast-1": {
        "table_name": "AWS-Tokyo",
        "network": ["10.102.0.0/17", "10.153.0.0/16"]
    },
    "eu-central-1": {
        "table_name": "AWS-Frankfurt/Ireland",
        "network": ["10.102.128.0/17", "10.156.0.0/16"]
    },
    "eu-west-1": {
        "table_name": "AWS-Frankfurt/Ireland",
        "network": ["10.102.128.0/17", "10.156.0.0/16"]
    }
}

# Table fields mapping
Field_Table_dict = {
    "numIps": "Number of IPs",
    "network": "Network",
    "netmask": "Netmask",
    "cidr": "CIDR",
    "IPrange": "Network IP Range",
    "broadcastIP": "Subnet Broadcast",
    "environment": "Environment",
    "service": "Service/Purpose",
    "accountID": "AWS Account ID",
    "tunnelIP1": "Tunnel IP 1",
    "tunnelIP2": "Tunnel IP 2",
    "description": "Description",
    "vpnID": "VPN ID",
    "vpcID": "VPC ID",
    "flowLogID": "Flow Log ID",
    "endSchedule": "Plan End Schedule",
    "creationDate": "Date of Creation",
    "contactPerson": "Contact Person",
    "ticket": "Ticket",
    "tunnelID": "Tunnel ID",
    "tgw": "TGW Connection"
}


def db_connection(f):
    """
    DB Connection decorator
    """

    @wraps(f)
    def decorator(*args, **kwargs):
        rds_host = rds_config.db_host
        name = rds_config.db_username
        password = rds_config.db_password
        db_name = rds_config.db_name

        try:
            conn = pymysql.connect(rds_host, user=name, passwd=password, db=db_name, connect_timeout=5)
            logger.info(f'Connected to {rds_host}')

            rv = f(conn, *args, **kwargs)
        except BaseException as e:
            logger.info(f'Error Connecting to RDS! {e}')

        else:
            logger.info(f"Disconnected from {rds_host}")
            conn.close()
            return rv

    return decorator


def generate_search_space_ipv4(boundary_list, ip_need):
    ## --- From Jaffer ----
    #
    # defensive programming
    #

    # 10.102.0.0/17 <-- Provided by Jaffer, 256 5/24= 10.102.0.0/24
    # Breakdown IP depending on number of IP
    assert boundary_list is not None, "Error: boundary_list cannot be None"

    assert len(boundary_list) > 0, "Error: boundary_list cannot be empty list"

    assert ip_need > 0, "Error: ip_need cannot less or equal than 0"

    assert math.log(ip_need, 2) % 1 == 0, "Error: ip_need must be log(2) based integer"

    #
    # normal logic
    #
    logger.info("Generating search space...")
    ip_need_mask = int(32 - math.log(ip_need, 2))

    result = []

    for b in boundary_list:

        # start point
        b_nw = ipaddress.IPv4Network(b)
        nw = ipaddress.IPv4Network("%s/%d" % (b.split('/')[0], ip_need_mask))

        while (nw.subnet_of(b_nw)):
            # nw in boundary
            result.append(nw)

            # move for next sibling
            nw = ipaddress.IPv4Network("%s/%d" % (str(nw.broadcast_address + 1), ip_need_mask))

    return result


@db_connection
def read_all_used_ips(connection, table):
    cursor = connection.cursor()
    # Read all IPs in the database

    logger.info("Reading all used address..")

    sql_string = f"SELECT `'CIDR'` from `'{table}'` where `'AWS Account ID'` != 'FREE'"

    cursor.execute(sql_string)

    result = [ipaddress.IPv4Network(str(x[0])) for x in cursor.fetchall()]

    return result


# List, List
# boundary_limitation_list = (256,256,256) [10.102.5.0/24]
# used_ip_cidr = (1024,256) [10,102.0.0/22,10.102.4.0/24]
def greedy_search(used_ip_cidr, boundary_limitation_list):
    logger.info("Searching for available network.")
    # Return first IP on the list when no records on database
    if used_ip_cidr is None:
        return boundary_limitation_list[0]

    try:
        while True:
            # Pop the index [0]
            # 10.102.0.0/24
            cidr = boundary_limitation_list.pop(0)
            overlapping_result = [cidr.overlaps(used_cidr) for used_cidr in used_ip_cidr]
            if True in overlapping_result:
                continue
            else:
                logger.info("Available network found.")
                return cidr
    except IndexError:
        return None


@db_connection
def allocate_host(connection, table, fields):
    cursor = connection.cursor()

    # Prepare query
    attributes = ",".join([f"`'{Field_Table_dict.get(x)}'`" for x in fields])
    insert_query = f"INSERT INTO `'{table}'` ({attributes}) VALUES ({('%s,' * len(fields))[:-1]})"

    cursor.execute(insert_query, tuple(fields.values()))
    connection.commit()
    return cursor.lastrowid


def share_resource():
    pass


def add_comment(**fields):
    options = {
        "auth": ('heinrichb', 'qwe123QWE!@#'),  # TODO: Update this
        "server": "https://dcstaskcentral.trendmicro.com/jira-stg"
    }

    jira = JIRA(**options)

    issue = jira.issue(fields['ticket'])
    reporter = issue.fields.reporter.key

    comment_template = f""" 
        Hi [~{reporter}],

        Please see IP allocation details as below 
        ||Network|| Netmask||CIDR||Number of IP's||Environment||Service/Purpose||AWS Account ID||Contact Person||Region ||
        | | | | | | | | |
        Here is the DCS Transit Gateway On-boarding SOP for your reference: https://cloudcntr.sdi.trendnet.org/x/kUx6B
        NOTE: As checked  Transit Gateway Resource Sharing Invitation (Oregon) has been sent to your account:056623867196 and 414724894558.
        Let us know if you need further support.

        Thanks and regards,
        AWS Central Admin    
    """

    jira.add_comment(issue, comment_template)

    return fields['ticket']


def lambda_handler(event, context):
    aws_region = next(iter(event.keys()))  # ex. ap-northeast-1

    assert aws_region in REGIONS_MAPPING, "Error: Invalid region."

    # Form data
    region = REGIONS_MAPPING[aws_region]["table_name"]
    number_of_IP = event[aws_region]['numIps']
    fields = event[aws_region]  #

    # 1a) Generate Search Space
    # [10.102.0.0/24...]
    search_space = generate_search_space_ipv4(REGIONS_MAPPING[aws_region]['network'], int(number_of_IP))

    # 1b) Read all Used IP's
    # From the DB
    used_ip = read_all_used_ips(region)

    available_cidr = greedy_search(used_ip, search_space)

    if available_cidr:

        hosts = list(available_cidr.hosts())  # 10.102.0.0/24 = [10.102.0.1.....10.102.0.254]

        fields.update({
            "network": str(available_cidr.network_address),
            "netmask": str(available_cidr.netmask),
            "cidr": str(available_cidr),
            "IPrange": f"{str(hosts[0])} to {str(hosts[-1])}",
            "broadcastIP": str(available_cidr.broadcast_address),
        })

        last_row_id = allocate_host(region, fields)

        # TODO: Share Code

        # TODO: refactor for multiple IP request on different region
        # add_comment(fields, region)

        return (f"Allocated {number_of_IP} number of hosts from  {available_cidr} in row {last_row_id}.")

    else:

        return ("Network is full. Please contact the administrators.")


