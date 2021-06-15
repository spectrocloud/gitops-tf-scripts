resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  assign_generated_ipv6_cidr_block = false
  enable_dns_hostnames = true
  enable_dns_support = true
  
  tags = merge(
    var.taggingstandard, 
    tomap({"Name" = "${lookup(var.taggingstandard,"deployment")}-VPC"})
  )
}