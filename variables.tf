variable "subnets" {
  description = "List of subnets where canary will be deployed"
  type        = list(any)
  default     = []
}

variable "subnet_use_tag" {
  description = "tag:use for the subnets where this Lambda is to run."
  type        = string
}

variable "vpc_use_tag" {
  description = "tag:use for the subnets where this Lambda is to run."
  type        = string
}

variable "shared_sg_use_tag" {
  description = "shared security group name tag"
  type        = string
}

variable "selected_sub" {
  description = "selected subnet name"
  type        = string
}

variable "environment" {
  description = "env this is being applied to"
  type        = string
  default     = "dev"
}

variable "script_scr" {
  description = "path to scripts, syncrepos.sh, etc"
  type        = string
  default     = ""
}

variable "name_prefix" {
  description = "name prefix for resources"
  type        = string
}