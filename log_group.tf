resource "aws_cloudwatch_log_group" "SSM_Patching_Preflight_Script_LogGroup" {
  name = "/aws/lambda/SSM-Patching-Preflight-Script"
}

resource "aws_cloudwatch_log_group" "SSM_Patching_Maint_Window_Check_LogGroup" {
  name = "/aws/lambda/SSM_Patching_Maint_Window_Check"
}

resource "aws_cloudwatch_log_group" "CloudTamer_App_API_Key_Renewal_LogGroup" {
  name = "/aws/lambda/CloudTamer-App-API-Key-Renewal"
}