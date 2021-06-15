resource "aws_subnet" "public" {
  count=var.aws_az_count

  vpc_id = aws_vpc.main.id
  cidr_block = cidrsubnet(lookup(var.IPSubnets, "subnetpublic"),1,count.index) 
  map_public_ip_on_launch = false
  availability_zone = element(var.aws_availability_zones,count.index)
  
  tags = merge(
    var.taggingstandard, 
    tomap({"Name" = "${lookup(var.taggingstandard,"deployment")}-Public ${count.index}"})
  )
}

resource "aws_subnet" "vpcendpoint" {
  count=var.aws_az_count

  vpc_id = aws_vpc.main.id
  cidr_block = cidrsubnet(lookup(var.IPSubnets, "subnetvpcendpoint"),1,count.index) 
  map_public_ip_on_launch = false
  availability_zone = element(var.aws_availability_zones,count.index)
  
  tags = merge(
    var.taggingstandard, 
    tomap({"Name" = "${lookup(var.taggingstandard,"deployment")}-VPC Endpoint ${count.index}"})
  )
}


resource "aws_route_table_association" "publicinternet" {
  count = 2

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.internetigw.id
}