resource "aws_cloudwatch_event_rule" "SSM_Patching_Preflight_MP_DEV" {
    description         = "Event rule to schedule the preflight script for MP DEV instances"
    event_bus_name      = "default"
    is_enabled          = true
    name                = "SSM-Patching-Preflight-MP-DEV"
    schedule_expression = "cron(0 13 ? * WED#2 *)"
    tags                = {}
    tags_all            = {}
}

resource "aws_cloudwatch_event_target" "SSM_Patching_Preflight_MP_DEV" {
  rule      = aws_cloudwatch_event_rule.SSM_Patching_Preflight_MP_DEV.name
  arn       = aws_lambda_function.SSM_Patching_Preflight_Script.arn

  depends_on = [aws_cloudwatch_event_rule.SSM_Patching_Preflight_MP_DEV, aws_lambda_function.SSM_Patching_Preflight_Script]
}

resource "aws_lambda_permission" "allow_SSM_Patching_Preflight_MP_DEV_to_call_SSM_Patching_Preflight_Script" {
    action = "lambda:InvokeFunction"
    function_name = aws_lambda_function.SSM_Patching_Preflight_Script.function_name
    source_arn = aws_cloudwatch_event_rule.SSM_Patching_Preflight_MP_DEV.arn
    principal = "events.amazonaws.com"

    depends_on = [aws_cloudwatch_event_rule.SSM_Patching_Preflight_MP_DEV,aws_lambda_function.SSM_Patching_Preflight_Script]
}

resource "aws_cloudwatch_event_target" "SSM_Patching_Maint_Window_Check_region1_MP_DEV" {
  rule      = aws_cloudwatch_event_rule.SSM_Patching_Preflight_MP_DEV.name
  arn       = aws_lambda_function.SSM_Patching_Maint_Window_Check_region1.arn

  depends_on = [aws_cloudwatch_event_rule.SSM_Patching_Preflight_MP_DEV, aws_lambda_function.SSM_Patching_Maint_Window_Check_region1]
}

resource "aws_lambda_permission" "allow_SSM_Patching_Preflight_MP_DEV_to_call_SSM_Patching_Maint_Window_Check_region1" {
    action = "lambda:InvokeFunction"
    function_name = aws_lambda_function.SSM_Patching_Maint_Window_Check_region1.function_name
    source_arn = aws_cloudwatch_event_rule.SSM_Patching_Preflight_MP_DEV.arn
    principal = "events.amazonaws.com"

    depends_on = [aws_cloudwatch_event_rule.SSM_Patching_Preflight_MP_DEV,aws_lambda_function.SSM_Patching_Maint_Window_Check_region1]
}

resource "aws_cloudwatch_event_target" "SSM_Patching_Maint_Window_Check_region2_MP_DEV" {
  rule      = aws_cloudwatch_event_rule.SSM_Patching_Preflight_MP_DEV.name
  arn       = aws_lambda_function.SSM_Patching_Maint_Window_Check_region2.arn

  depends_on = [aws_cloudwatch_event_rule.SSM_Patching_Preflight_MP_DEV, aws_lambda_function.SSM_Patching_Maint_Window_Check_region2]
}

resource "aws_lambda_permission" "allow_SSM_Patching_Preflight_MP_DEV_to_call_SSM_Patching_Maint_Window_Check_region2" {
    action = "lambda:InvokeFunction"
    function_name = aws_lambda_function.SSM_Patching_Maint_Window_Check_region2.function_name
    source_arn = aws_cloudwatch_event_rule.SSM_Patching_Preflight_MP_DEV.arn
    principal = "events.amazonaws.com"

    depends_on = [aws_cloudwatch_event_rule.SSM_Patching_Preflight_MP_DEV,aws_lambda_function.SSM_Patching_Maint_Window_Check_region2]
}

resource "aws_cloudwatch_event_rule" "SSM_Patching_Preflight_MP_PROD" {
    description         = "Event rule to schedule the preflight script for MP PROD instances"
    event_bus_name      = "default"
    is_enabled          = true
    name                = "SSM-Patching-Preflight-MP-PROD"
    schedule_expression = "cron(0 13 ? * SUN#4 *)"
    tags                = {}
    tags_all            = {}
}

resource "aws_cloudwatch_event_target" "SSM_Patching_Preflight_MP_PROD" {
  rule      = aws_cloudwatch_event_rule.SSM_Patching_Preflight_MP_PROD.name
  arn       = aws_lambda_function.SSM_Patching_Preflight_Script.arn

  depends_on = [aws_cloudwatch_event_rule.SSM_Patching_Preflight_MP_PROD, aws_lambda_function.SSM_Patching_Preflight_Script]
}

resource "aws_lambda_permission" "allow_SSM_Patching_Preflight_MP_PROD_to_call_SSM_Patching_Preflight_Script" {
    action = "lambda:InvokeFunction"
    function_name = aws_lambda_function.SSM_Patching_Preflight_Script.function_name
    source_arn = aws_cloudwatch_event_rule.SSM_Patching_Preflight_MP_PROD.arn
    principal = "events.amazonaws.com"

    depends_on = [aws_cloudwatch_event_rule.SSM_Patching_Preflight_MP_PROD,aws_lambda_function.SSM_Patching_Preflight_Script]
}

resource "aws_cloudwatch_event_target" "SSM_Patching_Maint_Window_Check_region1_MP_PROD" {
  rule      = aws_cloudwatch_event_rule.SSM_Patching_Preflight_MP_PROD.name
  arn       = aws_lambda_function.SSM_Patching_Maint_Window_Check_region1.arn

  depends_on = [aws_cloudwatch_event_rule.SSM_Patching_Preflight_MP_PROD, aws_lambda_function.SSM_Patching_Maint_Window_Check_region1]
}

resource "aws_lambda_permission" "allow_SSM_Patching_Preflight_MP_PROD_to_call_SSM_Patching_Maint_Window_Check_region1" {
    action = "lambda:InvokeFunction"
    function_name = aws_lambda_function.SSM_Patching_Maint_Window_Check_region1.function_name
    source_arn = aws_cloudwatch_event_rule.SSM_Patching_Preflight_MP_PROD.arn
    principal = "events.amazonaws.com"

    depends_on = [aws_cloudwatch_event_rule.SSM_Patching_Preflight_MP_PROD,aws_lambda_function.SSM_Patching_Maint_Window_Check_region1]
}

resource "aws_cloudwatch_event_target" "SSM_Patching_Maint_Window_Check_region2_MP_PROD" {
  rule      = aws_cloudwatch_event_rule.SSM_Patching_Preflight_MP_PROD.name
  arn       = aws_lambda_function.SSM_Patching_Maint_Window_Check_region2.arn

  depends_on = [aws_cloudwatch_event_rule.SSM_Patching_Preflight_MP_PROD, aws_lambda_function.SSM_Patching_Maint_Window_Check_region2]
}

resource "aws_lambda_permission" "allow_SSM_Patching_Preflight_MP_PROD_to_call_SSM_Patching_Maint_Window_Check_region2" {
    action = "lambda:InvokeFunction"
    function_name = aws_lambda_function.SSM_Patching_Maint_Window_Check_region2.function_name
    source_arn = aws_cloudwatch_event_rule.SSM_Patching_Preflight_MP_PROD.arn
    principal = "events.amazonaws.com"

    depends_on = [aws_cloudwatch_event_rule.SSM_Patching_Preflight_MP_PROD,aws_lambda_function.SSM_Patching_Maint_Window_Check_region2]
}

resource "aws_cloudwatch_event_rule" "SSM_Patching_Preflight_NonMP_PROD" {
    description         = "Event rule to schedule the preflight script for Non MP PROD instances"
    event_bus_name      = "default"
    is_enabled          = true
    name                = "SSM-Patching-Preflight-NonMP-PROD"
    schedule_expression = "cron(0 13 ? * WED#3 *)"
    tags                = {}
    tags_all            = {}
}

resource "aws_cloudwatch_event_target" "SSM_Patching_Preflight_NonMP_PROD" {
  rule      = aws_cloudwatch_event_rule.SSM_Patching_Preflight_NonMP_PROD.name
  arn       = aws_lambda_function.SSM_Patching_Preflight_Script.arn

  depends_on = [aws_cloudwatch_event_rule.SSM_Patching_Preflight_NonMP_PROD, aws_lambda_function.SSM_Patching_Preflight_Script]
}

resource "aws_lambda_permission" "allow_SSM_Patching_Preflight_NonMP_PROD_to_call_SSM_Patching_Preflight_Script" {
    action = "lambda:InvokeFunction"
    function_name = aws_lambda_function.SSM_Patching_Preflight_Script.function_name
    source_arn = aws_cloudwatch_event_rule.SSM_Patching_Preflight_NonMP_PROD.arn
    principal = "events.amazonaws.com"

    depends_on = [aws_cloudwatch_event_rule.SSM_Patching_Preflight_NonMP_PROD,aws_lambda_function.SSM_Patching_Preflight_Script]
}

resource "aws_cloudwatch_event_target" "SSM_Patching_Maint_Window_Check_region1_NonMP_PROD" {
  rule      = aws_cloudwatch_event_rule.SSM_Patching_Preflight_NonMP_PROD.name
  arn       = aws_lambda_function.SSM_Patching_Maint_Window_Check_region1.arn

  depends_on = [aws_cloudwatch_event_rule.SSM_Patching_Preflight_NonMP_PROD, aws_lambda_function.SSM_Patching_Maint_Window_Check_region1]
}

resource "aws_lambda_permission" "allow_SSM_Patching_Preflight_NonMP_PROD_to_call_SSM_Patching_Maint_Window_Check_region1" {
    action = "lambda:InvokeFunction"
    function_name = aws_lambda_function.SSM_Patching_Maint_Window_Check_region1.function_name
    source_arn = aws_cloudwatch_event_rule.SSM_Patching_Preflight_NonMP_PROD.arn
    principal = "events.amazonaws.com"

    depends_on = [aws_cloudwatch_event_rule.SSM_Patching_Preflight_NonMP_PROD,aws_lambda_function.SSM_Patching_Maint_Window_Check_region1]
}

resource "aws_cloudwatch_event_target" "SSM_Patching_Maint_Window_Check_region2_NonMP_PROD" {
  rule      = aws_cloudwatch_event_rule.SSM_Patching_Preflight_NonMP_PROD.name
  arn       = aws_lambda_function.SSM_Patching_Maint_Window_Check_region2.arn

  depends_on = [aws_cloudwatch_event_rule.SSM_Patching_Preflight_NonMP_PROD, aws_lambda_function.SSM_Patching_Maint_Window_Check_region2]
}

resource "aws_lambda_permission" "allow_SSM_Patching_Preflight_NonMP_PROD_to_call_SSM_Patching_Maint_Window_Check_region2" {
    action = "lambda:InvokeFunction"
    function_name = aws_lambda_function.SSM_Patching_Maint_Window_Check_region2.function_name
    source_arn = aws_cloudwatch_event_rule.SSM_Patching_Preflight_NonMP_PROD.arn
    principal = "events.amazonaws.com"

    depends_on = [aws_cloudwatch_event_rule.SSM_Patching_Preflight_NonMP_PROD,aws_lambda_function.SSM_Patching_Maint_Window_Check_region2]
}

resource "aws_cloudwatch_event_rule" "SSM_Patching_Preflight_NonMP_DEV" {
    description         = "Event rule to schedule the preflight script for Non MP DEV instances"
    event_bus_name      = "default"
    is_enabled          = true
    name                = "SSM-Patching-Preflight-NonMP-DEV"
    schedule_expression = "cron(0 13 ? * WED#2 *)"
    tags                = {}
    tags_all            = {}
}

resource "aws_cloudwatch_event_target" "SSM_Patching_Preflight_NonMP_DEV" {
  rule      = aws_cloudwatch_event_rule.SSM_Patching_Preflight_NonMP_DEV.name
  arn       = aws_lambda_function.SSM_Patching_Preflight_Script.arn

  depends_on = [aws_cloudwatch_event_rule.SSM_Patching_Preflight_NonMP_DEV, aws_lambda_function.SSM_Patching_Preflight_Script]
}

resource "aws_lambda_permission" "allow_SSM_Patching_Preflight_NonMP_DEV_to_call_SSM_Patching_Preflight_Script" {
    action = "lambda:InvokeFunction"
    function_name = aws_lambda_function.SSM_Patching_Preflight_Script.function_name
    source_arn = aws_cloudwatch_event_rule.SSM_Patching_Preflight_NonMP_DEV.arn
    principal = "events.amazonaws.com"

    depends_on = [aws_cloudwatch_event_rule.SSM_Patching_Preflight_NonMP_DEV,aws_lambda_function.SSM_Patching_Preflight_Script]
}

resource "aws_cloudwatch_event_target" "SSM_Patching_Maint_Window_Check_region1_NonMP_DEV" {
  rule      = aws_cloudwatch_event_rule.SSM_Patching_Preflight_NonMP_DEV.name
  arn       = aws_lambda_function.SSM_Patching_Maint_Window_Check_region1.arn

  depends_on = [aws_cloudwatch_event_rule.SSM_Patching_Preflight_NonMP_DEV, aws_lambda_function.SSM_Patching_Maint_Window_Check_region1]
}

resource "aws_lambda_permission" "allow_SSM_Patching_Preflight_NonMP_DEV_to_call_SSM_Patching_Maint_Window_Check_region1" {
    action = "lambda:InvokeFunction"
    function_name = aws_lambda_function.SSM_Patching_Maint_Window_Check_region1.function_name
    source_arn = aws_cloudwatch_event_rule.SSM_Patching_Preflight_NonMP_DEV.arn
    principal = "events.amazonaws.com"

    depends_on = [aws_cloudwatch_event_rule.SSM_Patching_Preflight_NonMP_DEV,aws_lambda_function.SSM_Patching_Maint_Window_Check_region1]
}

resource "aws_cloudwatch_event_target" "SSM_Patching_Maint_Window_Check_region2_NonMP_DEV" {
  rule      = aws_cloudwatch_event_rule.SSM_Patching_Preflight_NonMP_DEV.name
  arn       = aws_lambda_function.SSM_Patching_Maint_Window_Check_region2.arn

  depends_on = [aws_cloudwatch_event_rule.SSM_Patching_Preflight_NonMP_DEV, aws_lambda_function.SSM_Patching_Maint_Window_Check_region2]
}

resource "aws_lambda_permission" "allow_SSM_Patching_Preflight_NonMP_DEV_to_call_SSM_Patching_Maint_Window_Check_region2" {
    action = "lambda:InvokeFunction"
    function_name = aws_lambda_function.SSM_Patching_Maint_Window_Check_region2.function_name
    source_arn = aws_cloudwatch_event_rule.SSM_Patching_Preflight_NonMP_DEV.arn
    principal = "events.amazonaws.com"

    depends_on = [aws_cloudwatch_event_rule.SSM_Patching_Preflight_NonMP_DEV,aws_lambda_function.SSM_Patching_Maint_Window_Check_region2]
}

resource "aws_cloudwatch_event_rule" "SSM_Patching_Preflight_MP_IMPL" {
    description         = "Event rule to schedule the preflight script for MP IMPL instances"
    event_bus_name      = "default"
    is_enabled          = true
    name                = "SSM-Patching-Preflight-MP-IMPL"
    schedule_expression = "cron(0 13 ? * WED#2 *)"
    tags                = {}
    tags_all            = {}
}

resource "aws_cloudwatch_event_target" "SSM_Patching_Preflight_MP_IMPL" {
  rule      = aws_cloudwatch_event_rule.SSM_Patching_Preflight_MP_IMPL.name
  arn       = aws_lambda_function.SSM_Patching_Preflight_Script.arn

  depends_on = [aws_cloudwatch_event_rule.SSM_Patching_Preflight_MP_IMPL,aws_lambda_function.SSM_Patching_Preflight_Script]
}

resource "aws_lambda_permission" "allow_SSM_Patching_Preflight_MP_IMPL_to_call_SSM_Patching_Preflight_Script" {
    action = "lambda:InvokeFunction"
    function_name = aws_lambda_function.SSM_Patching_Preflight_Script.function_name
    source_arn = aws_cloudwatch_event_rule.SSM_Patching_Preflight_MP_IMPL.arn
    principal = "events.amazonaws.com"

    depends_on = [aws_cloudwatch_event_rule.SSM_Patching_Preflight_MP_IMPL,aws_lambda_function.SSM_Patching_Preflight_Script]
}

resource "aws_cloudwatch_event_target" "SSM_Patching_Maint_Window_Check_region1_MP_IMPL" {
  rule      = aws_cloudwatch_event_rule.SSM_Patching_Preflight_MP_IMPL.name
  arn       = aws_lambda_function.SSM_Patching_Maint_Window_Check_region1.arn

  depends_on = [aws_cloudwatch_event_rule.SSM_Patching_Preflight_MP_IMPL, aws_lambda_function.SSM_Patching_Maint_Window_Check_region1]
}

resource "aws_lambda_permission" "allow_SSM_Patching_Preflight_MP_IMPL_to_call_SSM_Patching_Maint_Window_Check_region1" {
    action = "lambda:InvokeFunction"
    function_name = aws_lambda_function.SSM_Patching_Maint_Window_Check_region1.function_name
    source_arn = aws_cloudwatch_event_rule.SSM_Patching_Preflight_MP_IMPL.arn
    principal = "events.amazonaws.com"

    depends_on = [aws_cloudwatch_event_rule.SSM_Patching_Preflight_MP_IMPL,aws_lambda_function.SSM_Patching_Maint_Window_Check_region1]
}

resource "aws_cloudwatch_event_target" "SSM_Patching_Maint_Window_Check_region2_MP_IMPL" {
  rule      = aws_cloudwatch_event_rule.SSM_Patching_Preflight_MP_IMPL.name
  arn       = aws_lambda_function.SSM_Patching_Maint_Window_Check_region2.arn

  depends_on = [aws_cloudwatch_event_rule.SSM_Patching_Preflight_MP_IMPL, aws_lambda_function.SSM_Patching_Maint_Window_Check_region2]
}

resource "aws_lambda_permission" "allow_SSM_Patching_Preflight_MP_IMPL_to_call_SSM_Patching_Maint_Window_Check_region2" {
    action = "lambda:InvokeFunction"
    function_name = aws_lambda_function.SSM_Patching_Maint_Window_Check_region2.function_name
    source_arn = aws_cloudwatch_event_rule.SSM_Patching_Preflight_MP_IMPL.arn
    principal = "events.amazonaws.com"

    depends_on = [aws_cloudwatch_event_rule.SSM_Patching_Preflight_MP_IMPL,aws_lambda_function.SSM_Patching_Maint_Window_Check_region2]
}