data "spectrocloud_cluster_profile" "vmware_infra" {
  name = "pds-vmware-infra"
}

data "spectrocloud_cluster_profile" "eks_infra" {
  name = "pds-eks-infra"
}

data "spectrocloud_cluster_profile" "pds_addon" {
  name = "pds-addon"
}

data "spectrocloud_cluster_profile" "pds_core" {
  name = "pds-core"
}