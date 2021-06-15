resource "aws_eip" "ngwip" {
  count = 2
  vpc   = true

  tags = merge(
    var.taggingstandard, 
    tomap({"Name" = "${lookup(var.taggingstandard,"deployment")}-InternetNAT${count.index}"})
  )
}

resource "aws_nat_gateway" "ngw" {
  count = 2 

  allocation_id = aws_eip.ngwip[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = merge(
    var.taggingstandard, 
    tomap({"Name" = "${lookup(var.taggingstandard,"deployment")}-NGW${count.index}"})
  )
}