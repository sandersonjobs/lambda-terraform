 #!/usr/bin/python3

import boto3
import re
import requests
import yaml
import json
import os

def lambda_handler(event, context):  
    sm = boto3.client('secretsmanager', 'us-east-1')
    api_token = sm.get_secret_value(SecretId=os.environ.get('cloudtamer_key_secret'))['SecretString']
    oc_account_num = os.environ.get('account_num')
    oc_iam_role = os.environ.get('iam_role')
    regions = os.environ.get('regions').split(",")
    ct_API_URL = os.environ.get('cloudtamer_url')
    account_files=os.environ.get('account_lists').split(",")

    for account_file in account_files:
        print(account_file,'\n')
        oc_cred_response=requests.post(url="{API_URL}/v3/temporary-credentials".format(API_URL=ct_API_URL), data=json.dumps({
                    "account_number": oc_account_num,
                    "iam_role_name": oc_iam_role 
                    }),headers={"Authorization":"Bearer {API_TOKEN}".format(API_TOKEN=api_token)})
        ssm = boto3.client('ssm',
            aws_access_key_id=oc_cred_response.json()['data']['access_key'],
            aws_secret_access_key=oc_cred_response.json()['data']['secret_access_key'],
            aws_session_token=oc_cred_response.json()['data']['session_token']
            )
        accounts_list = ssm.get_parameter(
                    Name="{file}".format(file=account_file)
                )['Parameter']['Value'].split(',')
        
        for region in regions:
            for account_num in accounts_list:
                account_response=requests.get(url="{API_URL}/v3/account/by-account-number/{cloudtamerAccountNumber}".format(API_URL=ct_API_URL,cloudtamerAccountNumber=account_num),headers={"Authorization":"Bearer {API_TOKEN}".format(API_TOKEN=api_token)})
                if account_response.status_code != 200:
                    print(account_num,":HTTP Status Code: ",account_response.status_code,",",account_response.json()['message'])
                elif account_response.status_code == 200:
                    cloud_access_role_response=requests.get(url="{API_URL}/v3/project/{id}/cloud-access-role".format(API_URL=ct_API_URL,id=account_response.json()['data']['project_id']),headers={"Authorization":"Bearer {API_TOKEN}".format(API_TOKEN=api_token)})
                    iam_role_name = cloud_access_role_response.json()['data']['ou_cloud_access_roles'][0]['aws_iam_role_name']
                    cred_response=requests.post(url="{API_URL}/v3/temporary-credentials".format(API_URL=ct_API_URL), data=json.dumps({
                        "account_number": "{x}".format(x=account_num),
                        "iam_role_name": iam_role_name
                        }),headers={"Authorization":"Bearer {API_TOKEN}".format(API_TOKEN=api_token)})
                    if cred_response.status_code != 200:
                        print(account_num,":HTTP Status Code: ",cred_response.status_code,",",cred_response.json()['message'])
                    elif cred_response.status_code == 200:
                        ssm = boto3.client('ssm',
                        aws_access_key_id=cred_response.json()['data']['access_key'],
                        aws_secret_access_key=cred_response.json()['data']['secret_access_key'],
                        aws_session_token=cred_response.json()['data']['session_token'], region_name=region)

                        cf = boto3.client('cloudformation',
                        aws_access_key_id=cred_response.json()['data']['access_key'],
                        aws_secret_access_key=cred_response.json()['data']['secret_access_key'],
                        aws_session_token=cred_response.json()['data']['session_token'], region_name=region)

                        stack_response = cf.describe_stacks()
                        ssm_response = ssm.describe_maintenance_windows(
                            Filters= [ { 'Key':'Enabled', 'Values':['True',] }, ],
                            MaxResults=50,
                        )

                        for stack in stack_response['Stacks']:
                            if re.findall(r'^ITOPS.+Maintenance-Windows',stack['StackName']):
                                cf_stack_params = stack['Parameters']
                                json_temp = json.loads(json.dumps(cf.get_template(StackName=stack['StackName'])))
                                try:
                                    template_yaml = yaml.load(json_temp['TemplateBody'], Loader=yaml.BaseLoader)
                                    cf_mw_dict = {}
                                    for resource in template_yaml['Resources'].items():
                                        if resource[1]['Type'] == 'AWS::SSM::MaintenanceWindow':
                                            for param in cf_stack_params:
                                                if resource[1]['Properties']['Name'].strip("\$\{\}") in param['ParameterKey']:
                                                    maint_window_name = param['ParameterValue']
                                                if resource[1]['Properties']['Schedule'] in param['ParameterKey']:
                                                    schedule = param['ParameterValue']
                                            cf_mw_dict[maint_window_name] = schedule

                                    ssm_mw_dict={}
                                    for ssm_window in ssm_response['WindowIdentities']:
                                        ssm_window_name = ssm_window['Name']
                                        ssm_window_schedule = ssm_window['Schedule']
                                        ssm_mw_dict[ssm_window_name] = ssm_window_schedule

                                    for mw in ssm_mw_dict.items():
                                        try:
                                            if mw[1] == cf_mw_dict[mw[0]]:
                                                pass
                                                #print("{ssm_mw_name} : same in SSM and Cloudformation".format(ssm_mw_name=mw[0]))
                                            else:
                                                print(region,":",account_num,":",account_response.json()['data']['account_name'],":","{ssm_mw_name} says {ssm_mw_schedule} in SSM and {cf_mw_schedule} in Cloudformation".format(ssm_mw_name=mw[0],ssm_mw_schedule=mw[1],cf_mw_schedule=cf_mw_dict[mw[0]]))
                                        except:
                                            print(region,":",account_num,":",account_response.json()['data']['account_name'],":","{ssm_mw_name} not found in Cloudformation Template".format(ssm_mw_name=mw[0]))
                                except BaseException as error:
                                    #print(error)
                                    print(region,":",account_num,":",account_response.json()['data']['account_name'],":","Cloudformation Template Corrupted")
      