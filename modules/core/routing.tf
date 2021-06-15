
resource "aws_route_table" "internetigw" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.taggingstandard, 
    tomap({"Name" = "${lookup(var.taggingstandard,"deployment")}-IGW"})
  )
}

resource "aws_route_table" "internetnat" {
  count=var.aws_az_count
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.taggingstandard, 
    tomap({"Name" = "${lookup(var.taggingstandard,"deployment")}-Internet${count.index}"})
  )
}


resource "aws_route" "internetnat" {
  count                  = 2
  route_table_id         = aws_route_table.internetnat[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.ngw[count.index].id
}

resource "aws_route" "internetigw" {
  route_table_id         = aws_route_table.internetigw.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id         = aws_internet_gateway.igw.id
}
