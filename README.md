
# [Horizon Engage User Onboarding](https://github.com/keithbenedicto-personal/Portfolio/tree/main/engage-user-onboarding)

* Created and architected a fully AWS Managed Web Application that conforms with security and needs of Asurion Dev Team
* Developed the application from the API, with python as its backend language for lambda up to the front-end using HTML and Javascript
* Uses different AWS services such as Cognito for user login, DynamoDB for logging, S3 bucket for static data and EC2 instance as its host
* Product is now in use for production and serves as a critical application tool for day to day tasks

# [Horizon Online Channel Training Environment](https://github.com/keithbenedicto-personal/Portfolio/tree/main/Horizon%20Online%20Channel%20Training%20Environment)

* Developed and deployed a training environment through Terraform that conforms to the actual production setup used by Asurion platform.
* Environment is composed of modularized AWS service terraform scripts, for easier deployment and debugging.
* Integrated into Jenkins as a CI/CD Pipeline to promote reusable deployment.

# [AWS Centralized Information](https://github.com/keithbenedicto-personal/Portfolio/tree/main/AWS%20Centralized%20Information)
* Developed a secured API which highlights the use of Python, Lambda, AWS API Gateway, RDS and S3 bucket to form a centralized repository of all AWS related information including internal IP allocation, account registration and pulling of information, AWS TGW connectivity, etc.
* Created a Web Application which uses the API mentioned above for easier access to customer intended

# [CCS Web Automation](https://github.com/keithbenedicto-personal/Portfolio/tree/main/CCS%20-%20Selenium)
* Created automation via Python and Selenium for TrendMicro's CCS Application to replicate the user experience and provide a temporary auto healing mechanism to the application
* Application usually crashes and a backend server reboot was signed as the temporary mitigation. This automation does the following
    1. Check and parse a healthcheck URL for the 3 backend servers present for the application
    2. Get the longest running machine and restart the application it via ssh library (paramiko)
    3. Check for the service status on the machine and see if client connections commence in to the server
    4. Provide logging system to see the time the issue has happened and if the script encountered errors.

# CCS Infrastructure Self-healing mechanism
* Created automation via Bash Script and third party tool OpsGenie to provide alert monitoring and self-healing to avoid business impairing incidents
    1. Integrated AWS Cloudwatch to OpsGenie to provide realtime monitoring to CCS infrastructure
    2. Provided alert level based troubleshooting scripts which will automatically run in case of an issue
        * Check concurrent connections for each web server
        * Check the longest-running web server and the one that caters most of the traffic
        * Restart IIS Service for a specific faulty server
        * Provide alert to respective on-call Engineer regarding the proposed step to be taken for validation 
# [Jenkins Web Automation](https://github.com/keithbenedicto-personal/Portfolio/tree/main/Jenkins%20-%20Selenium)
 * Created automation via Python and Selenium which mimics human intervention with servers by running a specific job based on the encountered issue
 * Application runs a set of the following functions below:
    1. Accept user input for the Provision Set (VM ID), Test script to use (AV or Backup) and the product type (OSCE,TMSM,etc.)
    2. Open a browser and login to jenkins and run the specific job based on the product with the following information stated.
      
        * Simple run of AV Test
        * If initial test fails, restart the IIS Service depending on the product type and after 10 minutes, rerun the AV Test.
        * If the AV Test still fails, get the VM credentials and restart the VM.
        * After 10 minutes, rerun the AV test to check if the service works fine.
        * Log each of the steps taken and if it succeeded or not.
      
# Samsung and Vodafone Trade Application
* Acted as main DevOps Engineer in building and architecting the whole AWS Infrastructure to be used for Samsung and Vodafone Trade Application Project.
* Created CI/CD pipelines for Development Team to use in deploying in different environment sets.
* Collaborated with Development Team in making sure that the application is working and compliant to all of Asurion’s protocols from all of the lower environments until product’s general availability.
* Supported product launch and handled relevant issues that concerns the service’s architecture.
* Proprietary, code and scripts cannot be disclosed.



      
