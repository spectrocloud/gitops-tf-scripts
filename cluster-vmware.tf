locals {
  cluster_vmware_files = fileset("${path.module}/config", "cluster-vmware-*.yaml")
  clusters_v = {
    for k in local.cluster_vmware_files :
    trimsuffix(k, ".yaml") => yamldecode(file("config/${k}"))
  }
}

################################  Clusters   ####################################################

# Create the VMware cluster
resource "spectrocloud_cluster_vsphere" "this" {
  for_each = local.clusters_v
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
    ssh_key = each.value.ssh_key
    datacenter = "Datacenter"
    folder     = "Demo/spc-${each.value.name}"
    network_type          = "DDNS"
    network_search_domain = "spectrocloud.local"
  }

  dynamic "machine_pool" {
    for_each = each.value.node_groups
    content {
      name                    = machine_pool.value.name
      count                   = machine_pool.value.count
      control_plane           = lookup(machine_pool.value, "control_plane", false)
      control_plane_as_worker = lookup(machine_pool.value, "control_plane_as_worker", false)
      dynamic "placement" {
        for_each = machine_pool.value.placements
        content {
          cluster       = placement.value.cluster
          resource_pool = placement.value.resourcepool
          datastore     = placement.value.datastore
          network       = placement.value.network
        }
      }
      instance_type {
        disk_size_gb = machine_pool.value.disk_size_gb
        memory_mb    = machine_pool.value.memory_mb
        cpu          = machine_pool.value.cpu
      }
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
}
