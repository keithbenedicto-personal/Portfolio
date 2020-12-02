from selenium import webdriver
from selenium.webdriver.common.keys import Keys
import time

ps = input("Please input the provision set: ")
sc = input("Please input the script type (av_test or backup): ")
prod = input("Please input the product type (OSCE, TMSM, OSCE/TMSM or TMCM): ")
user = 'keithb'
password = ''
driver = webdriver.Chrome("chromedriver.exe")
driver.get("https://epas-jenkins.trendmicro.com:8080/login")
driver.find_element_by_id("j_username").send_keys(user)
driver.find_element_by_name("j_password").send_keys(password)
driver.find_element_by_name("Submit").click()

def service(product): #To choose the product to be fixed!
	if product == "OSCE" or product == "TMSM" or product == "OSCE/TMSM":
		driver.find_element_by_xpath('//*[@id="main-panel"]/form/table/tbody[3]/tr[1]/td[3]/div/input[2]').click()
		driver.find_element_by_xpath('//*[@id="main-panel"]/form/table/tbody[4]/tr[1]/td[3]/div/input[2]').click()
	else:
		driver.find_element_by_xpath('//*[@id="main-panel"]/form/table/tbody[5]/tr[1]/td[3]/div/input[2]').click()

def master(prov_set,num): #To key in the provision set stated!
	job_type = ['ext-run-product-script','ext-restart product service','ext-credential','ext-restart-vm-and-landing']
	job = driver.find_element_by_id("search-box")
	job.send_keys(job_type[num])
	job.send_keys(Keys.ENTER)
	driver.find_element_by_xpath('//*[@id="job_master"]/td[3]/strong/a').click()
	driver.find_element_by_xpath('//*[@id="tasks"]/div[4]/a[2]').click()
	build = driver.find_element_by_xpath('//*[@id="main-panel"]/form/table/tbody[1]/tr[1]/td[3]/div/input[2]')
	build.send_keys(Keys.CONTROL,"a")
	build.send_keys(Keys.BACKSPACE)
	build.send_keys(prov_set)

def submit(): # To start bulding and check the console output
	driver.find_element_by_xpath('//*[@id="yui-gen1-button"]').click()
	time.sleep(300)	
	driver.find_element_by_xpath('//*[@id="buildHistory"]/div[2]/table/tbody/tr[2]/td/div[1]/a').click()
	driver.find_element_by_xpath('//*[@id="tasks"]/div[4]/a[2]').click()

def get_creds(prov_set,product): # To get credentials for VM and Restart VM if get credentials failed
	email = driver.find_element_by_xpath('//*[@id="main-panel"]/form/table/tbody[2]/tr[1]/td[3]/div/input[2]')
	email.send_keys(Keys.CONTROL,"a")
	email.send_keys(Keys.BACKSPACE)
	email.send_keys('keith_benedicto@trendmicro.com')
	driver.find_element_by_xpath('//*[@id="yui-gen1-button"]').click()
	time.sleep(240)
	driver.find_element_by_xpath('//*[@id="buildHistory"]/div[2]/table/tbody/tr[2]/td/div[1]/div[1]/a').click()
	driver.find_element_by_xpath('//*[@id="tasks"]/div[4]/a[2]').click()
	if ("Finished: SUCCESS" in driver.page_source):
		print(prov_set + " get credentials success! Build link under: " + driver.current_url)
	else:
		print(prov_set + " get credentials failed! Build link under: " + driver.current_url)
		master(prov_set,3)
		if product == "OSCE" or product == "TMSM" or product == "OSCE/TMSM":
			driver.find_element_by_xpath('//*[@id="main-panel"]/form/table/tbody[2]/tr[1]/td[3]/div/select/option[2]').click()
			submit()
		else:
			submit()
			if ("Finished: SUCCESS" in driver.page_source): # To restart the VM
				print(prov_set + " restart VM success! Build link under: " + driver.current_url)
				time.sleep(600) # wait 10 minutes to rerun AV Test
				master(prov_set,0)
				service(product)
				submit()
			else:
				print(prov_set + " restart VM failed! Build link under: " + driver.current_url)

def main(ps,sc,prod):
	prov_set = ps
	script_type = sc
	product = prod
	master(prov_set,0)
	script = driver.find_element_by_xpath('//*[@id="main-panel"]/form/table/tbody[2]/tr[1]/td[3]/div/select')
	if script_type == "av_test":
		script.find_element_by_xpath('//*[@id="main-panel"]/form/table/tbody[2]/tr[1]/td[3]/div/select/option[2]').click()
		service(product)
	elif script_type == "backup":
		script.find_element_by_xpath('//*[@id="main-panel"]/form/table/tbody[2]/tr[1]/td[3]/div/select/option[3]').click()
		service(product)
	submit()
	time.sleep(10)
	if ("Finished: SUCCESS" in driver.page_source):
		print(prov_set + " " + script_type + " run passed! Build link under: " + driver.current_url)
	else:
		print(prov_set + " " + script_type + " run failed! Build link under: " + driver.current_url)
		master(prov_set,1) # To restart the service stated	
		if product == "OSCE" or product == "TMSM" or product == "OSCE/TMSM": #Can't use the function service due to difference in tbody number used
			driver.find_element_by_xpath('//*[@id="main-panel"]/form/table/tbody[2]/tr[1]/td[3]/div/input[2]').click()
			driver.find_element_by_xpath('//*[@id="main-panel"]/form/table/tbody[3]/tr[1]/td[3]/div/input[2]').click()
		else:
			driver.find_element_by_xpath('//*[@id="main-panel"]/form/table/tbody[4]/tr[1]/td[3]/div/input[2]').click()
		submit()
		if ("Finished: SUCCESS" in driver.page_source):
			print(prov_set + " service restart success! Build link under: " + driver.current_url)
			time.sleep(600) # wait 10 minutes to rerun AV Test
			master(prov_set,0)
			service(product)
			submit()
			if ("Finished: SUCCESS" in driver.page_source):
				print(prov_set + " AV rerun after service restart success! Build link under: " + driver.current_url)
			else:
				master(prov_set,2)
				get_creds(prov_set,product)
		else:
			print(prov_set + " service restart failed! Build link under: " + driver.current_url)
			master(prov_set,2)
			get_creds(prov_set,product)
			
main(ps,sc,prod)



