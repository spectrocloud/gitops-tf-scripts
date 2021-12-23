terraform {
  required_version = ">= 0.14.0"

  required_providers {
    spectrocloud = {
      version = "~> 0.5.0"
      source  = "spectrocloud/spectrocloud"
    }
  }

  backend "s3" {
    bucket = "terraform-state-spectro-rishi"
    key    = "project-edison-demo/terraform.tfstate"
    region = "us-east-1"
  }
}

# Spectro Cloud
variable "sc_host" {}
variable "sc_username" {}
variable "sc_password" {}
variable "sc_project_name" {}

provider "spectrocloud" {
  host         = var.sc_host
  username     = var.sc_username
  password     = var.sc_password
  project_name = var.sc_project_name
}

# data "spectrocloud_cloudaccount_aws" "default" {
#   name = "aws-picard-2"
# }
