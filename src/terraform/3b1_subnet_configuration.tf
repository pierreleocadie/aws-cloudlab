#--------------------------------------#
# 3B1 SUBNET INTERNET ACCESS
#--------------------------------------#

resource "aws_route_table_association" "cloudlab_internal_subnet_3b1_route_table_association" {
    subnet_id      = aws_subnet.cloudlab_vpc_internal_subnet_3b1.id
    route_table_id = aws_route_table.cloudlab_public_route_table.id
}

#--------------------------------------#
# 3B1 SUBNET SECURITY GROUP
#--------------------------------------#
resource "aws_security_group" "cloudlab_internal_subnet_3b1_sg" {
    name        = "CloudLab Internal Subnet Security Group"
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
        description = "Allow all udp inbound traffic only from the cloudlab_vpc"
        from_port   = 0
        to_port     = 65535
        protocol    = "udp"
        cidr_blocks = [aws_vpc.cloudlab_vpc.cidr_block, "172.0.0.0/8"]
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
# 3B1 SUBNET EC2 INSTANCES
#--------------------------------------#
resource "aws_instance" "cloudlab_internal_server_1" {
    ami = local.debian11_arm64_ami # Debian 11
    instance_type = "t4g.micro"
    subnet_id = aws_subnet.cloudlab_vpc_internal_subnet_3b1.id
    private_ip = local.internal_server_1_private_ip
    key_name = local.key_name

    vpc_security_group_ids = [
        aws_security_group.cloudlab_internal_subnet_3b1_sg.id
    ]

    tags = {
        Name = "CloudLab Internal Server 1"
    }

    user_data = <<-EOF
    #!/bin/bash
    echo "cloudlab_internal_server_1" > /etc/hostname
    hostname -F /etc/hostname
    apt-get update
    apt-get install -y python3 python3-pip
    pip3 install ansible
    EOF
}

resource "aws_instance" "cloudlab_internal_server_2" {
    ami = local.debian11_arm64_ami # Debian 11
    instance_type = "t4g.micro"
    subnet_id = aws_subnet.cloudlab_vpc_internal_subnet_3b1.id
    private_ip = local.internal_server_2_private_ip
    key_name = local.key_name
    
    ebs_block_device {
        device_name = "/dev/xvda"
        volume_size = 20
        volume_type = "gp2"
    }

    vpc_security_group_ids = [
        aws_security_group.cloudlab_internal_subnet_3b1_sg.id
    ]

    tags = {
        Name = "CloudLab Internal Server 2"
    }

    user_data = <<-EOF
    #!/bin/bash
    echo "cloudlab_internal_server_2" > /etc/hostname
    hostname -F /etc/hostname
    apt-get update
    apt-get install -y python3 python3-pip
    pip3 install ansible
    EOF
}


#--------------------------------------#
# OUTPUTS
#--------------------------------------#
output "cloudlab_internal_server_1_ip" {
    value = aws_instance.cloudlab_internal_server_1.private_ip
}

output "cloudlab_nternal_server_2_ip" {
    value = aws_instance.cloudlab_internal_server_2.private_ip
}