resource "aws_vpc_endpoint" "s3" {
  vpc_id = aws_vpc.main.id
  service_name = "com.amazonaws.${var.aws_region}.s3"

  tags = merge(
    var.taggingstandard, 
    tomap({"Name" = "${lookup(var.taggingstandard,"deployment")}-S3"})
  )
}

resource "aws_vpc_endpoint_route_table_association" "s3vpcendpointNAT" {
  count=var.aws_az_count
  
  vpc_endpoint_id = aws_vpc_endpoint.s3.id
  route_table_id = aws_route_table.internetnat[count.index].id
}

resource "aws_vpc_endpoint_route_table_association" "s3vpcendpointIGW" {
  vpc_endpoint_id = aws_vpc_endpoint.s3.id
  route_table_id = aws_route_table.internetigw.id
}

resource "aws_vpc_endpoint" "ssmmessages" {
  vpc_id            = aws_vpc.main.id
  security_group_ids = [aws_security_group.vpcendpoint.id]
  subnet_ids        = aws_subnet.vpcendpoint[*].id
  service_name      = "com.amazonaws.${var.aws_region}.ssmmessages"
  vpc_endpoint_type = "Interface"
  private_dns_enabled = true
  
  tags = merge(
    var.taggingstandard, 
    tomap({"Name" = "${lookup(var.taggingstandard,"deployment")}-SSMessages"})
  )
}

resource "aws_vpc_endpoint" "ec2" {
  vpc_id            = aws_vpc.main.id
  security_group_ids = [aws_security_group.vpcendpoint.id]
  subnet_ids        = aws_subnet.vpcendpoint[*].id
  service_name      = "com.amazonaws.${var.aws_region}.ec2"
  vpc_endpoint_type = "Interface"

  private_dns_enabled = true
  
  tags = merge(
    var.taggingstandard, 
    tomap({"Name" = "${lookup(var.taggingstandard,"deployment")}-ec2"})
  )
}

resource "aws_vpc_endpoint" "ec2messages" {
  vpc_id            = aws_vpc.main.id
  security_group_ids = [aws_security_group.vpcendpoint.id]
  subnet_ids        = aws_subnet.vpcendpoint[*].id
  service_name      = "com.amazonaws.${var.aws_region}.ec2messages"
  vpc_endpoint_type = "Interface"

  private_dns_enabled = true
  
  tags = merge(
    var.taggingstandard, 
    tomap({"Name" = "${lookup(var.taggingstandard,"deployment")}-ec2messages"})
  )
}

resource "aws_vpc_endpoint" "ssm" {
  vpc_id            = aws_vpc.main.id
  security_group_ids = [aws_security_group.vpcendpoint.id]
  subnet_ids        = aws_subnet.vpcendpoint[*].id
  service_name      = "com.amazonaws.${var.aws_region}.ssm"
  vpc_endpoint_type = "Interface"

  private_dns_enabled = true
  
  tags = merge(
    var.taggingstandard, 
    tomap({"Name" = "${lookup(var.taggingstandard,"deployment")}-ssm"})
  )
}

resource "aws_vpc_endpoint" "kms" {
  vpc_id            = aws_vpc.main.id
  security_group_ids = [aws_security_group.vpcendpoint.id]
  subnet_ids        = aws_subnet.vpcendpoint[*].id
  service_name      = "com.amazonaws.${var.aws_region}.kms"
  vpc_endpoint_type = "Interface"

  private_dns_enabled = true
  
  tags = merge(
    var.taggingstandard, 
    tomap({"Name" = "${lookup(var.taggingstandard,"deployment")}-kms"})
  )
}

resource "aws_vpc_endpoint" "logs" {
  vpc_id            = aws_vpc.main.id
  security_group_ids = [aws_security_group.vpcendpoint.id]
  subnet_ids        = aws_subnet.vpcendpoint[*].id
  service_name      = "com.amazonaws.${var.aws_region}.logs"
  vpc_endpoint_type = "Interface"

  private_dns_enabled = true
  
  tags = merge(
    var.taggingstandard, 
    tomap({"Name" = "${lookup(var.taggingstandard,"deployment")}-logs"})
  )
}