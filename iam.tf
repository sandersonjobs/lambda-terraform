resource "aws_iam_role" "SSM-Preflight-Patching-Role" {
    assume_role_policy    = jsonencode(
        {
            Statement = [
                {
                    Action    = "sts:AssumeRole"
                    Effect    = "Allow"
                    Principal = {
                        Service = "lambda.amazonaws.com"
                    }
                },
            ]
            Version   = "2012-10-17"
        }
    )
    description           = "Allows Lambda functions to call AWS services on your behalf."
    force_detach_policies = false
    managed_policy_arns   = [
      aws_iam_policy.SSM-Preflight-Patching-Policy.arn,
    ]
    max_session_duration  = 3600
    name                  = "SSM-Preflight-Patching-Role"
    path                  = "/"
    tags                  = {}
    tags_all              = {}

    inline_policy {}

    depends_on = [ aws_iam_policy.SSM-Preflight-Patching-Policy, ]
}

resource "aws_iam_policy" "SSM-Preflight-Patching-Policy" {
    name      = "SSM-Preflight-Patching-Policy"
    path      = "/"
    policy    = jsonencode(
        {
            Statement = [
                {
                    Action   = "ec2:CreateNetworkInterface"
                    Effect   = "Allow"
                    Resource = [
                        "arn:aws:ec2:*:*:security-group/*",
                        "arn:aws:ec2:*:*:subnet/*",
                        "arn:aws:ec2:*:*:network-interface/*",
                    ]
                    Sid      = "VisualEditor0"
                },
                {
                    Action   = [
                        "logs:GetLogRecord",
                        "logs:DeleteSubscriptionFilter",
                        "secretsmanager:DescribeSecret",
                        "secretsmanager:PutSecretValue",
                        "logs:DescribeSubscriptionFilters",
                        "logs:StartQuery",
                        "secretsmanager:DeleteSecret",
                        "logs:DescribeMetricFilters",
                        "logs:ListLogDeliveries",
                        "logs:CreateLogStream",
                        "ec2:CreateNetworkInterfacePermission",
                        "logs:CancelExportTask",
                        "logs:DeleteRetentionPolicy",
                        "logs:GetLogEvents",
                        "logs:FilterLogEvents",
                        "ec2:DescribeNetworkInterfacePermissions",
                        "logs:DescribeDestinations",
                        "ec2:DeleteNetworkInterface",
                        "ec2:ResetNetworkInterfaceAttribute",
                        "ec2:AttachNetworkInterface",
                        "logs:StopQuery",
                        "logs:DeleteQueryDefinition",
                        "logs:CreateLogGroup",
                        "ec2:CreateNetworkInterface",
                        "logs:PutMetricFilter",
                        "logs:CreateLogDelivery",
                        "logs:DescribeExportTasks",
                        "logs:GetQueryResults",
                        "logs:UpdateLogDelivery",
                        "secretsmanager:UpdateSecretVersionStage",
                        "logs:PutSubscriptionFilter",
                        "secretsmanager:ListSecrets",
                        "logs:ListTagsLogGroup",
                        "logs:DescribeLogStreams",
                        "secretsmanager:CreateSecret",
                        "logs:DeleteLogStream",
                        "logs:GetLogDelivery",
                        "secretsmanager:ListSecretVersionIds",
                        "logs:CreateExportTask",
                        "logs:DeleteMetricFilter",
                        "secretsmanager:GetSecretValue",
                        "secretsmanager:ReplicateSecretToRegions",
                        "ec2:DeleteNetworkInterfacePermission",
                        "ec2:DetachNetworkInterface",
                        "ec2:DescribeNetworkInterfaces",
                        "secretsmanager:RestoreSecret",
                        "secretsmanager:RotateSecret",
                        "logs:DeleteLogDelivery",
                        "logs:AssociateKmsKey",
                        "logs:DescribeQueryDefinitions",
                        "logs:PutDestination",
                        "logs:DescribeResourcePolicies",
                        "logs:DescribeQueries",
                        "logs:DisassociateKmsKey",
                        "logs:DescribeLogGroups",
                        "logs:DeleteLogGroup",
                        "logs:PutDestinationPolicy",
                        "logs:TestMetricFilter",
                        "secretsmanager:CancelRotateSecret",
                        "logs:PutQueryDefinition",
                        "logs:DeleteDestination",
                        "logs:PutLogEvents",
                        "secretsmanager:UpdateSecret",
                        "logs:PutRetentionPolicy",
                        "logs:GetLogGroupFields",
                    ]
                    Effect   = "Allow"
                    Resource = "*"
                    Sid      = "VisualEditor1"
                },
            ]
            Version   = "2012-10-17"
        }
    )
    tags      = {}
    tags_all  = {}
}

