resource "aws_security_group" "vpcendpoint" {
  name        = "${lookup(var.taggingstandard,"deployment")}-VPCEndpoints"
  description = "Security Group for VPC Endpoints"
  vpc_id      = aws_vpc.main.id

  tags = merge(
    var.taggingstandard, 
    tomap({"Name" = "${lookup(var.taggingstandard,"deployment")}-VPCEndpoints"})
  )
}

# Allow all outbound traffic
resource "aws_security_group_rule" "VPCEEgress" {
  security_group_id = aws_security_group.vpcendpoint.id
  description       = "Allow All Egress"

  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "all"
  cidr_blocks       = ["0.0.0.0/0"]
}

# Allow HTTP Traffic (TCP/80) from Public Subnet
resource "aws_security_group_rule" "HTTPSFromVPCE" {
  security_group_id = aws_security_group.vpcendpoint.id
  description       = "Allow HTTP Igress from VPC Endpoints"

  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "all"
  cidr_blocks       = ["0.0.0.0/0"]
}