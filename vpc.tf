data "aws_vpcs" "shared_vpc" {
    tags = {
    Name = var.vpc_use_tag
  }
}

data "aws_security_groups" "shared_svcs_sg" {
  filter {
    name   = "tag:Name"
    values = [var.shared_sg_use_tag]
  }

  filter {
    name   = "vpc-id"
    values = [tolist(data.aws_vpcs.shared_vpc.ids)[0]]
  }
}

data "aws_subnet" "selected_sub" {
  filter {
    name   = "vpc-id"
    values = [tolist(data.aws_vpcs.shared_vpc.ids)[0]]
  }
    id       = var.selected_sub
}