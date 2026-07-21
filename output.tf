output "aws_vpc" {
    value = aws_vpc.chuks_vpc.id
}

output "subnet_id" {
    value = aws_subnet.public_subnet.id
}

output "internet_gateway_id" {
    value = aws_internet_gateway.chuks_igw.id
}

output "route_table_id" {
    value = aws_route_table.chuks_rt.id
}

output "security_group_id" {
    value = aws_security_group.chuks_SG.id
}