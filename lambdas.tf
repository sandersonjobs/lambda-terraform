resource "aws_lambda_function" "ct_api_renewal" {
    function_name                  = "CloudTamer-App-API-Key-Renewal"
    handler                        = "CloudTamer-App-API-Key-Renewal.lambda_handler"
    memory_size                    = 128
    package_type                   = "Zip"
    reserved_concurrent_executions = -1
    role                           = aws_iam_role.SSM-Preflight-Patching-Role.arn
    runtime                        = "python3.9"
    timeout                        = 30
    filename = "CloudTamer-App-API-Key-Renewal.zip"

    ephemeral_storage {
        size = 512
    }

    tracing_config {
        mode = "PassThrough"
    }

    environment {
        variables = {
            cloudtamer_url = "https://cloudtamer.cms.gov/api",
            cloudtamer_key_secret = "cloudtamer-api-key",
            account_num = "842420567215",
            account_iam_role = "ct-gss-ado-admin"
            }
            }
    
    vpc_config {
        security_group_ids = [aws_security_group.ct_renew_sg.id]
        subnet_ids         = [data.aws_subnet.selected_sub.id]
        }

    depends_on = [null_resource.cloudtamer_app_api_key_renewal_zip, aws_security_group.ct_renew_sg, aws_cloudwatch_log_group.CloudTamer_App_API_Key_Renewal_LogGroup, aws_iam_role.SSM-Preflight-Patching-Role, ]
}

resource "aws_lambda_alias" "ct_api_renewal_alias" {
  name             = "API_Key_Renewal_alias"
  function_name    = aws_lambda_function.ct_api_renewal.function_name
  function_version = "$LATEST"

  depends_on = [aws_lambda_function.ct_api_renewal,]
}

resource "aws_lambda_permission" "allow_secretsmanager" {
  statement_id  = "Allow_Secrets_Manager"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.ct_api_renewal.function_name
  principal     = "secretsmanager.amazonaws.com"
  source_arn    = aws_secretsmanager_secret.cloudtamer_api_key.arn

  depends_on = [aws_lambda_function.ct_api_renewal,aws_lambda_alias.ct_api_renewal_alias, aws_secretsmanager_secret.cloudtamer_api_key]
}

resource "aws_lambda_function" "SSM_Patching_Preflight_Script" {
    function_name                  = "SSM-Patching-Preflight-Script"
    handler                        = "SSM-Patching-Preflight-Script.lambda_handler"
    memory_size                    = 128
    package_type                   = "Zip"
    reserved_concurrent_executions = -1
    role                           = aws_iam_role.SSM-Preflight-Patching-Role.arn
    runtime                        = "python3.9"
    timeout                        = 900
    filename = "SSM-Patching-Preflight-Script.zip"

    ephemeral_storage {
        size = 512
    }

    tracing_config {
        mode = "PassThrough"
    }

    environment {
        variables = {
            cloudtamer_url = "https://cloudtamer.cms.gov/api",
            regions = "us-east-1,us-west-2",
            cloudtamer_key_secret = "cloudtamer-api-key",
            account_lists = "/ITOPS/ssm-patching/non-marketplace/accounts,/ITOPS/ssm-patching/marketplace/accounts",
            iam_role = "ct-gss-ado-admin",
            account_num = "842420567215"
            }
            }
    
    vpc_config {
        security_group_ids = [aws_security_group.ct_renew_sg.id,tolist(data.aws_security_groups.shared_svcs_sg.ids)[0]]
        subnet_ids         = [data.aws_subnet.selected_sub.id]
        }

    depends_on = [
        null_resource.SSM_Patching_Preflight_Script,
        aws_ssm_document.ssm_preflight_script,
        aws_security_group.ct_renew_sg,
    aws_cloudwatch_event_rule.SSM_Patching_Preflight_MP_DEV, 
    aws_cloudwatch_event_rule.SSM_Patching_Preflight_MP_PROD, 
    aws_cloudwatch_event_rule.SSM_Patching_Preflight_NonMP_PROD, 
    aws_cloudwatch_event_rule.SSM_Patching_Preflight_NonMP_DEV, 
    aws_cloudwatch_event_rule.SSM_Patching_Preflight_MP_IMPL,
    aws_cloudwatch_log_group.SSM_Patching_Preflight_Script_LogGroup,
    aws_secretsmanager_secret.cloudtamer_api_key,
    aws_ssm_parameter.marketplace_accounts, 
    aws_ssm_parameter.non_marketplace_accounts
    ]
}

resource "aws_lambda_function" "SSM_Patching_Maint_Window_Check_region1" {
    function_name                  = "SSM-Patching-Maintenance-Window-Check_region1"
    handler                        = "SSM-Patching-Maintenance-Window-Check_region1.lambda_handler"
    memory_size                    = 128
    package_type                   = "Zip"
    reserved_concurrent_executions = -1
    role                           = aws_iam_role.SSM-Preflight-Patching-Role.arn
    runtime                        = "python3.9"
    timeout                        = 900
    filename = "SSM-Patching-Maintenance-Window-Check.zip"

    ephemeral_storage {
        size = 512
    }

    tracing_config {
        mode = "PassThrough"
    }

    layers = [aws_lambda_layer_version.yaml_layer.arn]

    environment {
        variables = {
            cloudtamer_url = "https://cloudtamer.cms.gov/api",
            regions = "us-east-1",
            cloudtamer_key_secret = "cloudtamer-api-key",
            account_lists = "/ITOPS/ssm-patching/non-marketplace/accounts,/ITOPS/ssm-patching/marketplace/accounts",
            iam_role = "ct-gss-ado-admin",
            account_num = "842420567215"
            }
            }
    
    vpc_config {
        security_group_ids = [aws_security_group.ct_renew_sg.id,tolist(data.aws_security_groups.shared_svcs_sg.ids)[0]]
        subnet_ids         = [data.aws_subnet.selected_sub.id]
        }

    depends_on = [
        null_resource.SSM_Patching_Maint_Window_Check,
        aws_security_group.ct_renew_sg,
    aws_cloudwatch_event_rule.SSM_Patching_Preflight_MP_DEV, 
    aws_cloudwatch_event_rule.SSM_Patching_Preflight_MP_PROD, 
    aws_cloudwatch_event_rule.SSM_Patching_Preflight_NonMP_PROD, 
    aws_cloudwatch_event_rule.SSM_Patching_Preflight_NonMP_DEV, 
    aws_cloudwatch_event_rule.SSM_Patching_Preflight_MP_IMPL,
    aws_cloudwatch_log_group.SSM_Patching_Maint_Window_Check_LogGroup,
    aws_lambda_layer_version.yaml_layer,
    aws_secretsmanager_secret.cloudtamer_api_key,
    aws_ssm_parameter.marketplace_accounts, 
    aws_ssm_parameter.non_marketplace_accounts
    ]
}

resource "aws_lambda_function" "SSM_Patching_Maint_Window_Check_region2" {
    function_name                  = "SSM-Patching-Maintenance-Window-Check_region2"
    handler                        = "SSM-Patching-Maintenance-Window-Check_region2.lambda_handler"
    memory_size                    = 128
    package_type                   = "Zip"
    reserved_concurrent_executions = -1
    role                           = aws_iam_role.SSM-Preflight-Patching-Role.arn
    runtime                        = "python3.9"
    timeout                        = 900
    filename = "SSM-Patching-Maintenance-Window-Check.zip"

    ephemeral_storage {
        size = 512
    }

    tracing_config {
        mode = "PassThrough"
    }

    layers = [aws_lambda_layer_version.yaml_layer.arn]

    environment {
        variables = {
            cloudtamer_url = "https://cloudtamer.cms.gov/api",
            regions = "us-west-2",
            cloudtamer_key_secret = "cloudtamer-api-key",
            account_lists = "/ITOPS/ssm-patching/non-marketplace/accounts,/ITOPS/ssm-patching/marketplace/accounts",
            iam_role = "ct-gss-ado-admin",
            account_num = "842420567215"
            }
            }
    
    vpc_config {
        security_group_ids = [aws_security_group.ct_renew_sg.id,tolist(data.aws_security_groups.shared_svcs_sg.ids)[0]]
        subnet_ids         = [data.aws_subnet.selected_sub.id]
        }

    depends_on = [
        null_resource.SSM_Patching_Maint_Window_Check,
        aws_security_group.ct_renew_sg,
    aws_cloudwatch_event_rule.SSM_Patching_Preflight_MP_DEV, 
    aws_cloudwatch_event_rule.SSM_Patching_Preflight_MP_PROD, 
    aws_cloudwatch_event_rule.SSM_Patching_Preflight_NonMP_PROD, 
    aws_cloudwatch_event_rule.SSM_Patching_Preflight_NonMP_DEV, 
    aws_cloudwatch_event_rule.SSM_Patching_Preflight_MP_IMPL,
    aws_cloudwatch_log_group.SSM_Patching_Maint_Window_Check_LogGroup,
    aws_lambda_layer_version.yaml_layer,
    aws_secretsmanager_secret.cloudtamer_api_key,
    aws_ssm_parameter.marketplace_accounts, 
    aws_ssm_parameter.non_marketplace_accounts
    ]
}