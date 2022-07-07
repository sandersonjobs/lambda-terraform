terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.12.1"
    }
  }

  required_version = "1.0.7"
}

locals {
  env = "dev"
}

provider "aws" {
  default_tags {
    tags = {
      cms-cloud-environment = local.env
      cms-cloud-technology  = "terraform"
      cms-cloud-component   = "ssm-patching"
    }
  }
}

module "ssm_lambda" {
  source         = "../.."
  script_scr     = "../../../scripts"
  environment    = local.env
  vpc_use_tag    = "itops-east-dev"
  subnet_use_tag = "private"
  selected_sub   = "subnet-0aef6a3aa875cded5"
  name_prefix    = "ssm-patching"
  shared_sg_use_tag = "cmscloud-shared-services"
}