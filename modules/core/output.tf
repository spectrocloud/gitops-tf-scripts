output "aws_vpc_main_id" {
  value = aws_vpc.main.id
}

output "aws_subnet_public_id" {
  value = aws_subnet.public.*.id
}

output "aws_subnet_public_cidr" {
  value = aws_subnet.public.*.id
}

output "aws_route_table_internetigw_id"{
  value = aws_route_table.internetigw.id
}

output "aws_route_table_internetnat_id" {
  value = aws_route_table.internetnat.*.id
}
output "aws_nat_gateway_ngw_id" {
  value = aws_nat_gateway.ngw.*.id
}

output "aws_route_internetnat" {
  value = aws_route.internetnat.*.id
}

output "aws_internet_gateway_igw_id" {
  value = aws_internet_gateway.igw.id
}

output "aws_route_internetigw_id" {
  value = aws_route.internetigw.id
}

output "aws_route_table_association_publicinternet_id" {
  value = aws_route_table_association.publicinternet.*.id
}