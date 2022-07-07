 #!/usr/bin/python3

import boto3
import re
import requests
import json
import os

def lambda_handler(event, context):  
    print(event)
    ssm = boto3.client('ssm')
    environment = event['environment']
    marketplace = event['marketplace']
    if marketplace == True:
        accounts_list = ssm.get_parameter(
            Name='/ITOPS/ssm-patching/marketplace/accounts'
        )['Parameter']['Value'].split(',')
        if environment == 'PROD':
            patch_windows = ssm.get_parameter(
            Name='/ITOPS/ssm-patching/marketplace/prod-patch-windows'
        )['Parameter']['Value'].split(',')
        elif environment == 'IMPL':
            patch_windows = ssm.get_parameter(
            Name='/ITOPS/ssm-patching/marketplace/impl-patch-windows'
        )['Parameter']['Value'].split(',')
        else:
            patch_windows = ssm.get_parameter(
            Name='/ITOPS/ssm-patching/marketplace/dev-patch-windows'
        )['Parameter']['Value'].split(',')
    else:
        accounts_list = ssm.get_parameter(
            Name='/ITOPS/ssm-patching/non-marketplace/accounts'
        )['Parameter']['Value'].split(',')
        if environment == 'PROD':
            patch_windows = ssm.get_parameter(
            Name='/ITOPS/ssm-patching/non-marketplace/prod-patch-windows'
        )['Parameter']['Value'].split(',')
        else:
            patch_windows = ssm.get_parameter(
            Name='/ITOPS/ssm-patching/non-marketplace/dev-patch-windows'
        )['Parameter']['Value'].split(',')

    if marketplace:
        response = ssm.start_automation_execution(
            DocumentName='SSM-Patching-Preflight-Script',
            Parameters={
                'patchWindows': patch_windows[:3],
                'environment': [environment]
            },
            TargetLocations=[
                {
                    'Accounts': accounts_list,
                    'Regions': [
                        'us-east-1'
                    ],
                    'TargetLocationMaxConcurrency': '25',
                    'TargetLocationMaxErrors': '100%',
                    'ExecutionRoleName': 'ccs-pwc-patching-role'
                },
            ]
        )
        print(response)
        response = ssm.start_automation_execution(
            DocumentName='SSM-Patching-Preflight-Script',
            Parameters={
                'patchWindows': patch_windows[3:],
                'environment': [environment]
            },
            TargetLocations=[
                {
                    'Accounts': accounts_list,
                    'Regions': [
                        'us-east-1'
                    ],
                    'TargetLocationMaxConcurrency': '25',
                    'TargetLocationMaxErrors': '100%',
                    'ExecutionRoleName': 'ccs-pwc-patching-role'
                },
            ]
        )
        print(response)
    else:
        response = ssm.start_automation_execution(
            DocumentName='SSM-Patching-Preflight-Script',
            Parameters={
                'patchWindows': patch_windows,
                'environment': [environment]
            },
            TargetLocations=[
                {
                    'Accounts': accounts_list,
                    'Regions': [
                        'us-east-1'
                    ],
                    'TargetLocationMaxConcurrency': '25',
                    'TargetLocationMaxErrors': '100%',
                    'ExecutionRoleName': 'ccs-pwc-patching-role'
                },
            ]
        )
        print(response)
    return response