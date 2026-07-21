variable "cidr" {
    type = string
    description = "a variable for custom aws vpc"
    default = "10.0.0.0/16"
}
variable "subnet_cidr" {
    type = string
    description = "a variable pointing to main file custom subnet creation"
    default = "10.0.0.0/24"
}
variable "internet_gateway_name" {
    type = string
    description = "internet_gateway"
    default = "Nwachukwu"
}
variable "route_table_name" {
    type = string
    description = "a variable for creating custom route-table"
    default = "Nwachukwu-route-table"
}

variable "aws_ebs_volume" {
    type = number
    default = 20
}

