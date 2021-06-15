# Core Deployment Information
variable env { type = string }
variable application { type = string }
variable uai { type = string }
variable aws_region { type = string }
variable aws_az_count { type = number }
variable aws_availability_zones { type = list }

# Virtual Network Infomration
variable vpc_cidr { type = string }

# Locals Brought Over
variable IPSubnets { type = map }
variable taggingstandard { type = map}