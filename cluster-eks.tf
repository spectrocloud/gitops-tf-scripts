locals {
  cluster_files = fileset("${path.module}/config", "cluster-eks-*.yaml")
  clusters = {
    for k in local.cluster_files :
    trimsuffix(k, ".yaml") => yamldecode(file("config/${k}"))
  }
}

################################  Clusters   ####################################################
resource "spectrocloud_cluster_eks" "this" {
  for_each = local.clusters
  name     = each.value.name

  cluster_profile {
    id = local.profile_ids[each.value.profiles.infra]
  }

  cluster_profile {
    id = data.spectrocloud_cluster_profile.pds_addon.id
  }

  cluster_profile {
    id = data.spectrocloud_cluster_profile.pds_core.id
  }

  cloud_account_id = local.account_ids[each.value.cloud_account]

  cloud_config {
    ssh_key_name        = lookup(each.value.cloud_config, "ssh_key", "")
    region              = lookup(each.value.cloud_config, "aws_region", "")
    vpc_id              = lookup(each.value.cloud_config, "aws_vpc_id", "")
    az_subnets          = lookup(each.value.cloud_config, "eks_subnets", {})
    azs                 = []
    public_access_cidrs = []
  }

  dynamic "machine_pool" {
    for_each = each.value.node_groups
    content {
      name          = machine_pool.value.name
      count         = machine_pool.value.count
      instance_type = machine_pool.value.instance_type
      az_subnets    = lookup(machine_pool.value, "worker_subnets", {})
      disk_size_gb  = machine_pool.value.disk_size_gb
      azs           = []
    }
  }

  dynamic "backup_policy" {
    for_each = try(tolist([each.value.backup_policy]), [])
    content {
      schedule                  = backup_policy.value.schedule
      backup_location_id        = local.bsl_ids[backup_policy.value.backup_location]
      prefix                    = backup_policy.value.prefix
      expiry_in_hour            = 7200
      include_disks             = true
      include_cluster_resources = true
    }
  }

  dynamic "scan_policy" {
    for_each = try(tolist([each.value.scan_policy]), [])
    content {
      configuration_scan_schedule = scan_policy.value.configuration_scan_schedule
      penetration_scan_schedule   = scan_policy.value.penetration_scan_schedule
      conformance_scan_schedule   = scan_policy.value.conformance_scan_schedule
    }
  }

  dynamic "fargate_profile" {
    for_each = try(each.value.fargate_profiles, [])
    content {
      name            = fargate_profile.value.name
      subnets         = fargate_profile.value.subnets
      additional_tags = fargate_profile.value.additional_tags
      dynamic "selector" {
        for_each = fargate_profile.value.selectors
        content {
          namespace = selector.value.namespace
          labels    = selector.value.labels
        }
      }
    }
  }
}
