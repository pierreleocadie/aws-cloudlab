terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
        }
    }
}

provider "aws" {
    region = "eu-west-3"
}

locals {
    debian11_arm64_ami = "ami-07a87dd0dd0b306ee"
    key_name = "HomelabInfra"
    public_facing_entrypoint_private_ip = "10.0.1.11"
    app_projects_server_private_ip = "10.0.1.12"
    internal_server_1_private_ip = "10.0.2.11"
    internal_server_2_private_ip = "10.0.2.12"
}

resource "aws_vpc" "cloudlab_vpc" {
    cidr_block = "10.0.0.0/16"

    tags = {
        Name = "CloudLab Infrastructure VPC"
    }
}

resource "aws_subnet" "cloudlab_vpc_public_facing_subnet_3a1" {
    vpc_id                  = aws_vpc.cloudlab_vpc.id
    cidr_block              = "10.0.1.0/24"
    availability_zone       = "eu-west-3a"
    map_public_ip_on_launch = true

    tags = {
        Name = "CloudLab Public Subnet a1"
    }
}

resource "aws_subnet" "cloudlab_vpc_internal_subnet_3b1" {
    vpc_id                  = aws_vpc.cloudlab_vpc.id
    cidr_block              = "10.0.2.0/24"
    availability_zone       = "eu-west-3b"
    map_public_ip_on_launch = true

    tags = {
        Name = "CloudLab Internal Subnet b1"
    }
}

#--------------------------------------#
# INTERNET ACCESS
#--------------------------------------#
resource "aws_internet_gateway" "cloudlab_vpc_igw" {
    vpc_id = aws_vpc.cloudlab_vpc.id
}

resource "aws_route_table" "cloudlab_public_route_table" {
    vpc_id = aws_vpc.cloudlab_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.cloudlab_vpc_igw.id
    }

    tags = {
        Name = "CloudLab Public Route Table"
    }
}

