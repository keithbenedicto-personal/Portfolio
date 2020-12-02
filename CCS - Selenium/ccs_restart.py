import paramiko, time, datetime, logging, signal, atexit, getpass
from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from plyer import notification
from fabric import Connection

logging.basicConfig(filename = 'log.txt', level = logging.INFO)
driver = webdriver.Chrome("chromedriver.exe")

def send_notif(msg):
	notification.notify(
	    title='CCS Script',
	    message=msg,
	    app_name = 'CCS Alerts',
	    app_icon = 'icon.ico'
	)

def login(usr, pw):
	user = usr
	password = pw

	driver.get("https://adfssts.trendmicro.com/adfs/ls/IdpInitiatedSignon.aspx")
	driver.find_element_by_name("SignInOtherSite").click()
	aws = driver.find_element_by_xpath('//*[@id="idp_RelyingPartyDropDownList"]')
	aws.click()
	aws.send_keys(Keys.DOWN)
	aws.send_keys(Keys.ENTER)
	driver.find_element_by_id("idp_SignInButton").click()
	driver.find_element_by_name("UserName").send_keys(user)
	driver.find_element_by_name("Password").send_keys(password)
	driver.find_element_by_id("submitButton").click()
	time.sleep(10)
	driver.switch_to.frame(driver.find_element_by_id("duo_iframe"))
	driver.find_element_by_xpath("//*[@id='auth_methods']/fieldset/div[1]/button").click()
	time.sleep(10)
	driver.switch_to.default_content()
	driver.find_element_by_id("3").click()
	driver.find_element_by_id("signin_button").click()
	driver.find_element_by_id("search-box-input").send_keys("cloudwatch", Keys.ENTER)
	time.sleep(5)
	driver.find_element_by_id("gwt-debug-dashboardsLink").click()
	time.sleep(3)
	ccs = driver.find_element_by_xpath("//*[@id='gwt-debug-dashboards']/div/div/div/div[1]/section[3]/div/table/tbody/tr[1]/td[1]/a")
	ccs.click()
	time.sleep(10)

def get_longest(usr, pw):
	ccs_ip_list = ['10.96.182.138', '10.96.182.117', '10.96.182.112']
	dur_list = []
	for i in ccs_ip_list:
		c = Connection(i, user=usr, port=22, connect_kwargs={"password":pw})	
		ps_res = str(c.run('ps aux|grep tmmsccs', hide=True)).replace('=== stdout ===','').replace('Command exited with status 0.','').replace('(no stderr)','')
		split_ps = list(filter(None, ps_res.split('\n')))

		for i in split_ps:
			if 'python /var/tmmsccs/tmmsccs.py -d' in i:
				ref = list(filter(None,i.split(' ')))
				for x in ref:
					if x =='root':
						target_pid = ref[ref.index(x)+1]

		elapsed_dur = str(c.run('ps -p ' + target_pid + ' -o etime', hide=True)).replace('=== stdout ===','').replace('Command exited with status 0.','').replace('(no stderr)','')
		elapsed_dur = list(filter(None,elapsed_dur.split('\n')))
		elapsed_dur = elapsed_dur[1].replace(' ','')
		elapsed_dur = elapsed_dur.split(':')

		if len(elapsed_dur) == 3:
			if '-' in elapsed_dur[0]:
				temp_hour_dur = elapsed_dur[0].split('-')
				temp_hour_dur[0] = str(int(temp_hour_dur[0])*24)
				elapsed_dur[0] = str(int(temp_hour_dur[0])+int(temp_hour_dur[1]))

			total_dur_secs = int(elapsed_dur[0])*3600 + int(elapsed_dur[1])*60 + int(elapsed_dur[2])
		elif len(elapsed_dur) == 2:
			total_dur_secs = int(elapsed_dur[0])*60 + int(elapsed_dur[1])
		else:
			total_dur_secs = int(elapsed_dur[1])
		dur_list.append(total_dur_secs)

	target_idx = dur_list.index(max(dur_list))
	print('Longest running server is ' + ccs_ip_list[target_idx])
	return(ccs_ip_list[target_idx])

def restart_server(x, c, d):
	#variables for the target server and credentials
	host = x	
	username = c
	password = d

	#connect to the target host
	ssh = paramiko.SSHClient()
	ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
	ssh.connect(host, username=username, password=password)
	print('connected to', host)

	stdin, stdout, ssh_stderr = ssh.exec_command('/sbin/service tmmsccs status', get_pty=True)
	print('\n'.join(stdout.readlines()))
	
	shell = ssh.invoke_shell()

	def send_string_and_wait(command, wait_time, should_print):
	    # Send the su command
	    shell.send(command)

	    # Wait a bit, if necessary
	    time.sleep(wait_time)

	    # Flush the receive buffer
	    receive_buffer = shell.recv(1024)

	    # Print the receive buffer, if necessary
	    if should_print:
	        print(receive_buffer)

	send_string_and_wait("sudo /sbin/service tmmsccs stop\n", 1, True)
	send_string_and_wait(password + "\n", 1, True)
	time.sleep(5)
	send_string_and_wait("sudo /sbin/service tmmsccs start\n", 1, True) 
	time.sleep(5)
	stdin, stdout, ssh_stderr = ssh.exec_command('/sbin/service tmmsccs status', get_pty=True)
	print('\n'.join(stdout.readlines()))

def terminate(signal, frame):
    print(str(datetime.datetime.now())+"KeyboardInterrupt detected. Program terminated.")
    logging.info(str(datetime.datetime.now())+"Program terminated by KeyboardInterrupt")
    send_notif('CCS Script has encountered an error. Apply appropriate action.')
    exit()

def exit():
    print(str(datetime.datetime.now())+'Error encountered')
    logging.info(str(datetime.datetime.now())+"Error encountered. Program exited")
    send_notif('CCS Script has encountered an error. Apply appropriate action.')

aws_user = input("AWS Username: ")
aws_user = 'TRENDPH\\' + aws_user
aws_pass = getpass.getpass()
ipa_user = input("IPA Username: ")
ipa_pass = getpass.getpass()

login(aws_user,aws_pass)
signal.signal(signal.SIGINT, terminate)
atexit.register(exit)

while True:
	try:
		driver.refresh()
		time.sleep(30)
		el = driver.find_elements_by_class_name("cwdb-single-value-number-value")[5]
		if el.text.isnumeric():
			res = int(el.text)
		else:
			res = False

		if res!=False:
			if res>=800:
				msg1 = str(datetime.datetime.now()) + ' Spillover Threshold Breached! CURRENT AMOUNT: ' + str(res)
				print(msg1)
				logging.critical(msg1)

				msg2 = str(datetime.datetime.now()) + ' Restart Initiated'
				print(msg2)
				logging.critical(msg2)

				restart_server(get_longest(ipa_user, ipa_pass), ipa_user, sdi_pass)

				msg3 = str(datetime.datetime.now()) + ' Restart Completed'
				print(msg3)
				logging.info(msg3)
				time.sleep(40)
			else:
				msg = str(datetime.datetime.now()) + ' Spillover Count Rising! CURRENT AMOUNT: ' + str(res)
				print(msg)
				logging.warning(msg)
		else:
			msg = str(datetime.datetime.now()) + ' No Spillovers'
			print(msg)
			logging.info(msg)
		
		time.sleep(30)
		signal.signal(signal.SIGINT, terminate)
		atexit.register(exit)
	except(ConnectionError, TimeoutError):
		continue