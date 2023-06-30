#--------------------------------------#
# A1 SUBNET INTERNET ACCESS
#--------------------------------------#

resource "aws_route_table_association" "cloudlab_public_facing_subnet_3a1_route_table_association" {
    subnet_id      = aws_subnet.cloudlab_vpc_public_facing_subnet_3a1.id
    route_table_id = aws_route_table.cloudlab_public_route_table.id
}

#--------------------------------------#
# A1 SUBNET SECURITY GROUP
#--------------------------------------#
resource "aws_security_group" "cloudlab_public_facing_subnet_3a1_sg" {
    name        = "CloudLab Public Facing Subnet Security Group"
    description = "Allow all inbound and outbound traffic within the cloudlab_vpc"
    vpc_id      = aws_vpc.cloudlab_vpc.id

    ingress {
        description = "Allow all tcp inbound traffic within the cloudlab_vpc"
        from_port   = 0
        to_port     = 65535
        protocol    = "tcp"
        cidr_blocks = [aws_vpc.cloudlab_vpc.cidr_block, "172.0.0.0/8"]
    }

    ingress {
        description = "Allow all udp inbound traffic within the cloudlab_vpc"
        from_port   = 0
        to_port     = 65535
        protocol    = "udp"
        cidr_blocks = [aws_vpc.cloudlab_vpc.cidr_block, "172.0.0.0/8"]
    }

    ingress {
        description = "Allow udp inbound traffic for Wireguard VPN from anywhere"
        from_port   = 51820
        to_port     = 51820
        protocol    = "udp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "Allow HTTPS inbound traffic from anywhere"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        description = "Allow all outbound traffic to anywhere"
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

#--------------------------------------#
# A1 SUBNET EC2 INSTANCES
#--------------------------------------#
resource "aws_instance" "cloudlab_public_facing_entrypoint" {
    ami = local.debian11_arm64_ami # Debian 11
    instance_type = "t4g.micro"
    subnet_id = aws_subnet.cloudlab_vpc_public_facing_subnet_3a1.id
    private_ip = local.public_facing_entrypoint_private_ip
    key_name = local.key_name

    vpc_security_group_ids = [
        aws_security_group.cloudlab_public_facing_subnet_3a1_sg.id
    ]

    tags = {
        Name = "CloudLab Public Facing Entrypoint"
    }

    user_data = <<-EOF
    #!/bin/bash
    echo "cloudlab_public_facing_entrypoint" > /etc/hostname
    hostname -F /etc/hostname
    apt-get update
    apt-get install -y python3 python3-pip
    pip3 install ansible
    EOF
}

resource "aws_eip" "public_facing_entrypoint_eip" {
    vpc = true
    instance = aws_instance.cloudlab_public_facing_entrypoint.id
}

resource "aws_eip_association" "public_facing_entrypoint_eip_association" {
    instance_id   = aws_instance.cloudlab_public_facing_entrypoint.id
    allocation_id = aws_eip.public_facing_entrypoint_eip.id
}

resource "aws_instance" "cloudlab_public_app_projects_server" {
    ami = local.debian11_arm64_ami # Debian 11
    instance_type = "t4g.micro"
    subnet_id = aws_subnet.cloudlab_vpc_public_facing_subnet_3a1.id
    private_ip = local.app_projects_server_private_ip
    key_name = local.key_name

    vpc_security_group_ids = [
        aws_security_group.cloudlab_public_facing_subnet_3a1_sg.id
    ]

    tags = {
        Name = "CloudLab Public App Projects Server"
    }

    user_data = <<-EOF
    #!/bin/bash
    echo "cloudlab_public_app_projects_server > /etc/hostname
    hostname -F /etc/hostname
    apt-get update
    apt-get install -y python3 python3-pip
    pip3 install ansible
    EOF
}

#--------------------------------------#
# OUTPUTS
#--------------------------------------#
output "cloudlab_public_facing_entrypoint_ip" {
    value = aws_instance.cloudlab_public_facing_entrypoint.private_ip
}

output "cloudlab_public_app_projects_server_ip" {
    value = aws_instance.cloudlab_public_app_projects_server.private_ip
}