import boto3
import json
import os
import requests

def renew_cloudtamer_api_key():
    sm = boto3.client('secretsmanager', 'us-east-1')
    print('Trying to get cloudtamer api key')
    cloudtamer_url = os.environ.get('cloudtamer_url')
    print("Got cloudtamer URL")
    cloudtamer_api_key = sm.get_secret_value(SecretId=os.environ.get('cloudtamer_key_secret'))['SecretString']
    if cloudtamer_api_key:
        print('Got the cloudtamer api key')
        payload = {"key": cloudtamer_api_key}
        try:
            print('Trying to rotate the api key in cloudtamer')
            response = requests.post(
            "{cloudtamer_url}/v3/app-api-key/rotate".format(cloudtamer_url=cloudtamer_url), 
            headers={"Authorization": "Bearer {cloudtamer_api_key}".format(cloudtamer_api_key=cloudtamer_api_key)}, 
            data=json.dumps(payload)
            )

            if response.status_code == 201:
                print('New app api key successfully created')
                new_key = response.json()["data"]["key"]
                print('Trying to update the api key in secrets manager')
                try:
                    sm.update_secret(
                        SecretId=os.environ.get('cloudtamer_key_secret'),
                        SecretString=new_key
                    )
                    print('Updated the api key in secrets manager')
                except BaseException as error:
                    print('Something went wrong and the key was not updated in Secrets Manager')
                    print(error)
            else:
                print('Something went wrong and a new API key was not created')
                print(response.status_code)
                print(response.json())
        except BaseException as error:
            print(error)
            exit()
    else:
        print('Did not get the cloudtamer api key')
    
def lambda_handler(event, context):
    renew_cloudtamer_api_key()