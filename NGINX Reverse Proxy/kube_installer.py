import boto3
import sys
import subprocess
import os

# Define the version prefix to search for
full_version_prefix = sys.argv[1]
version_prefix = full_version_prefix[:4]  # Only include the first two digits

s3 = boto3.client('s3')

# List all objects in the 'amazon-eks' S3 bucket that match the version prefix
response = s3.list_objects_v2(Bucket='amazon-eks', Prefix=version_prefix)
kubectl_objects = [{'url': obj['Key'].replace('/aws-kubectl/', '/aws-kubectl/{}/bin/linux/amd64/kubectl'.format(full_version_prefix)), 'last_modified': obj['LastModified']} for obj in response['Contents'] if obj['Key'].endswith('/bin/linux/amd64/kubectl')]
kubectl_objects.sort(key=lambda obj: obj['last_modified'], reverse=True)
latest_kubectl_url = kubectl_objects[0]['url'] # Get the URL of the latest 'kubectl' object
print('kubectlURL:', latest_kubectl_url)

# Curl the appropriate version for installation
try:
    subprocess.run(['curl', '-LO', f'https://s3.us-west-2.amazonaws.com/amazon-eks/{latest_kubectl_url}'])
    subprocess.run(['chmod', '+x', './kubectl'])
    os.system('mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$PATH:$HOME/bin')
    os.system("echo 'export PATH=$PATH:$HOME/bin' >> ~/.bashrc")
except Exception as err:
    print('Error installing kubectl: ', err)