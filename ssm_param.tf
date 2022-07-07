resource "aws_ssm_parameter" "marketplace_accounts" {
    arn       = "arn:aws:ssm:us-east-1:656395180286:parameter/ITOPS/ssm-patching/marketplace/accounts"
    data_type = "text"
    name      = "/ITOPS/ssm-patching/marketplace/accounts"
    tags      = {}
    tags_all  = {}
    tier      = "Standard"
    type      = "StringList"
    value     = "Update to list of accounts"
}

resource "aws_ssm_parameter" "non_marketplace_accounts" {
    arn       = "arn:aws:ssm:us-east-1:*:parameter/ITOPS/ssm-patching/non-marketplace/accounts"
    data_type = "text"
    name      = "/ITOPS/ssm-patching/non-marketplace/accounts"
    tags      = {}
    tags_all  = {}
    tier      = "Standard"
    type      = "StringList"
    value     = "Update to list of accounts"
}