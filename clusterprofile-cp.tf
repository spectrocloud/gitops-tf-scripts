locals {
  profiles_files = fileset("${path.module}/config", "profile-*.yaml")
  cluster_profiles = {
    for k in local.profiles_files :
    trimsuffix(k, ".yaml") => yamldecode(file("config/${k}"))
  }
}

################################  Cluster Profile #################################################

locals {
  profile_ids = merge({
      eks-infra    = data.spectrocloud_cluster_profile.eks_infra.id
    }, {
      vmware-infra = data.spectrocloud_cluster_profile.vmware_infra.id
    }, {
      for k, v in spectrocloud_cluster_profile.this :
        v.name => v.id
  })
}

resource "spectrocloud_cluster_profile" "this" {
  for_each = local.cluster_profiles
  name     = each.value.name

  description = each.value.description
  type        = each.value.type

  dynamic "pack" {
    for_each = each.value.packs
    content {
      name   = pack.value.name
      type   = pack.value.type
      values = <<-EOT
        pack:
          spectrocloud.com/install-priority: "${pack.value.install-priority}"
      EOT
    }
  }
}
