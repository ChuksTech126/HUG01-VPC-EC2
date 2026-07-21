terraform {
    backend "s3" {
        bucket = "chukschuks"
        key = "terraform.tfstate"
        region = "us-east-1"
        dynamodb_table = "terraform-locks"
        encrypt = true
    }
}

    provider "aws"{
        region = "us-east-1"
    }
    resource "aws_vpc" "chuks_vpc" {
        cidr_block = var.cidr
    }
    resource "aws_subnet" "public_subnet" {
        vpc_id = aws_vpc.chuks_vpc.id
        cidr_block = var.subnet_cidr
        availability_zone = "us-east-1a"
        map_public_ip_on_launch = true
    } 
    resource "aws_internet_gateway" "chuks_igw" {
        vpc_id = aws_vpc.chuks_vpc.id
    }
    resource "aws_route_table" "chuks_rt" {
        vpc_id = aws_vpc.chuks_vpc.id
        route  {
            cidr_block = "0.0.0.0/0"
            gateway_id = aws_internet_gateway.chuks_igw.id
        }
    }
    resource "aws_route_table_association" "chuks_aws_route_table_association" {
        subnet_id = aws_subnet.public_subnet.id
        route_table_id = aws_route_table.chuks_rt.id
    }

    resource "aws_security_group" "chuks_SG" {
        name = "chuks-SG"
        vpc_id = aws_vpc.chuks_vpc.id

        ingress {
            from_port = 80 
            to_port  = 80
            protocol = "tcp"
            cidr_blocks = ["0.0.0.0/0"] 
        }

        ingress {
            from_port = 22
            to_port = 22
            protocol = "tcp"
            cidr_blocks = ["0.0.0.0/0"]
        }

        egress {
            from_port = 0 
            to_port = 0 
            protocol = "-1"
            cidr_blocks = ["0.0.0.0/0"]
        }
    
    }
    resource "aws_instance" "chuk_web" {
        ami = "ami-0b6d9d3d33ba97d99"
        key_name = "chuks"
        instance_type = "t3.micro"
        subnet_id = aws_subnet.public_subnet.id
        vpc_security_group_ids = [aws_security_group.chuks_SG.id]
        associate_public_ip_address = true

        tags = {
            Name = "Chuks_web"
        }
        user_data =<<-EOF
        #!/bin/bash
        sudo apt update -y
        sudo apt upgrade -y
        sudo apt install nginx -y
        sudo systemctl start nginx
        sudo systemctl enable nginx
        echo "<h>Abraham, NWACHUKWU</h1><h2>HUG Lagos/Ibadan Terraform Challenge</h2/> " >>/var/www/html/index.html
        EOF


    }
    resource "aws_ebs_volume" "chuks_ebs" {
        availability_zone = "us-east-1a"
        size = 20
    }
    resource "aws_volume_attachment" "ebs_attach" {
        device_name = "/dev/sdf"
        volume_id   = aws_ebs_volume.chuks_ebs.id
        instance_id = aws_instance.chuk_web.id
    }