locals {
  core_files = fileset("${path.module}/config", "core-*.yaml")
  coremodules = {
  for k in local.core_files :
  trimsuffix(k, ".yaml") => yamldecode(file("config/${k}"))
  }
//
//  cloud_entities = {
//  for k, v in module.core :
//  v.env => v
//  }

  cloud_entities = merge({
    for entry in local.coremodules :
    entry.tags.env => entry
  })

  env_vpc_id = {
  for k, v in module.core :
  v.env => v.aws_vpc_main_id
  }

  env_subnets = {
  for k, v in module.core :
  v.env => v.eks_subnets
  }
}

module "core" {
  for_each = local.coremodules
  source   = "./modules/core"
  # Core Deployment Information
  env         = each.value.tags.env
  application = each.value.tags.application
  uai         = each.value.tags.uai
  aws_region             = each.value.aws_region
  aws_az_count           = each.value.aws_az_count
  aws_availability_zones = each.value.aws_availability_zones
  # Virtual Network Infomration
  vpc_cidr = each.value.vpc_cidr
  # Locals Brought  Over
  IPSubnets = {
    subnetpublic      = cidrsubnet(each.value.vpc_cidr, 4, 0) # Auto splits to two /27s - 10.0.0.0/27 and 10.0.0.32/27
    subnetvpcendpoint = cidrsubnet(each.value.vpc_cidr, 4, 1) # Auto splits to two /27s - 10.0.0.64/27 and 10.0.0.96/27
  }
  taggingstandard = {
    env         = each.value.tags.env
    application = each.value.tags.application
    uai         = each.value.tags.uai
    deployment  = "${each.value.tags.application}-${each.value.tags.env}-${random_string.deploymentid.result}"
    aws_region  = each.value.aws_region
  }
}

resource "random_string" "deploymentid" {
  length  = 6
  special = false
}