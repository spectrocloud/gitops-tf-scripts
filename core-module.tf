locals {
  core_module_files = fileset("${path.module}/config", "core-module.yaml")
  core_modules = {
  for k in local.core_module_files :
  trimsuffix(k, ".yaml") => yamldecode(file("config/${k}"))
  }

  # rbac_yaml    = yamldecode(file("rbac.yaml"))
  # rbac_all_crb = lookup(local.rbac_yaml.all_clusters, "clusterRoleBindings", [])
  # rbac_all_rb  = lookup(local.rbac_yaml.all_clusters, "namespaces", [])
  # rbac_all_crb = lookup(local.rbac_yaml.all_clusters, "clusterRoleBindings", [])
  # rbac_all_rb  = lookup(local.rbac_yaml.all_clusters, "namespaces", [])
  #
  # rbac_map = {
  #   for k, v in local.rbac_yaml.clusters :
  #   k => {
  #     clusterRoleBindings = concat(local.rbac_all_crb, lookup(v, "clusterRoleBindings", []))
  #     namespaces        = concat(local.rbac_all_rb, lookup(v, "namespaces", []))
  #   }
  # }
}

module "core" {
  for_each = local.core_modules
  source = "./modules/core"

  # Core Deployment Information
  env                    = each.value.tags.env
  application            = each.value.tags.application
  uai                    = each.value.tags.uai
  aws_region             = each.value.tags.aws_region
  aws_az_count           = each.value.tags.aws_az_count
  aws_availability_zones = each.value.tags.aws_availability_zones

  # Virtual Network Infomration
  vpc_cidr = each.value.tags.vpc_cidr

  # Locals Brought Over
//  IPSubnets       = each.value.tags.iPSubnets
//  taggingstandard = each.value.tags.taggingstandard
}