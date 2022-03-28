locals {
  accounts = {
    for k in fileset("config/account", "account-*.yaml") :
    trimsuffix(k, ".yaml") => yamldecode(file("config/account/${k}"))
  }

  bsls = {
    for k in fileset("config/bsl", "bsl-*.yaml") :
    trimsuffix(k, ".yaml") => yamldecode(file("config/bsl/${k}"))
  }

  profiles = {
    for k in fileset("config/profile", "profile-*.yaml") :
    trimsuffix(k, ".yaml") => yamldecode(file("config/profile/${k}"))
  }

  appliances = {
    for k in fileset("config/appliance", "appliance-*.yaml") :
    trimsuffix(k, ".yaml") => yamldecode(file("config/appliance/${k}"))
  }

  clusters = {
    for k in fileset("config/cluster", "cluster-*.yaml") :
    trimsuffix(k, ".yaml") => yamldecode(file("config/cluster/${k}"))
  }
}

module "Spectro" {
  source = "/Users/rishi/work/git_clones/terraform-spectrocloud-modules"
  #source  = "spectrocloud/modules/spectrocloud"
  #version = "0.0.7"

  accounts   = local.accounts
  bsls       = local.bsls
  profiles   = local.profiles
  appliances = local.appliances
}

module "SpectroClusters" {
  depends_on = [module.Spectro]
  source     = "/Users/rishi/work/git_clones/terraform-spectrocloud-modules"
  #source  = "spectrocloud/modules/spectrocloud"
  #version = "0.0.7"

  clusters = local.clusters
}
