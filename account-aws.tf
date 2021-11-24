locals {
  account_files = fileset("${path.module}/config", "account-aws-*.yaml")
  accounts = {
    for k in local.account_files :
    trimsuffix(k, ".yaml") => yamldecode(file("config/${k}"))
  }

  # TODO refactor to separate file
  account_ids = merge({
    picard-vc2 = "609946e4dba160e6c97aa130"
    aws-eks    = "609c506e2bfeae8682408ffb"
    }, {
    for k, v in spectrocloud_cloudaccount_aws.this :
    v.name => v.id
  })
}

################################  accounts   ####################################################

# Create the VMware account
resource "spectrocloud_cloudaccount_aws" "this" {
  for_each = local.accounts

  type        = "sts"
  name        = each.value.name
  arn         = each.value.arn
  external_id = each.value.external_id
}
