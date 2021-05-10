# Create Security Group - ZabbixServer
resource "aws_security_group" "zabbix-server" {
  vpc_id      = aws_vpc.vpc.id
  name        = "Zabbix-Server"
  description = "Security Group for the Zabbix Server."

  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = var.my_ip_addresses
  }
  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = var.zabbix_access_allowed_ip_addresses
  }
  ingress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = var.zabbix_access_allowed_ip_addresses
  }
  ingress {
    protocol    = "tcp"
    from_port   = 10050
    to_port     = 10051
    cidr_blocks = var.zabbix_service_allowed_ip_addresses
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"] # service can communitcate out withou restrictions, change it if needed
  }

  tags = {
    Name        = "Zabbix-Server"
    Application = "Zabbix Server"
  }
}
# Create EC2 Instance - ZabbixServer
resource "aws_instance" "instance-zabbix-server" {
  instance_type               = "t3a.small"
  ami                         = var.ec2_image_id
  vpc_security_group_ids      = [aws_security_group.zabbix-server.id]
  subnet_id                   = aws_subnet.public-subnet-1.id
  key_name                    = var.ec2_key_name
  associate_public_ip_address = true
  user_data                   = file("user-data.sh")

  tags = {
    Name        = "Zabbix-Server"
    Application = "Zabbix Server"
  }
}
# Create EIP for EC2 Instance ZabbixServer
resource "aws_eip" "eip-instance-zabbix-server" {

  instance = aws_instance.instance-zabbix-server.id
  vpc      = true

  tags = {
    Name = "Zabbix-Server"
  }
}

# Output
output "zabbixserver-eip" {
  value = "http://${aws_eip.eip-instance-zabbix-server.public_ip}/zabbix"
}

output "User" {
  value = "Admin"
}

output "SSH-User" {
  value = "ubuntu"
}

output "Password" {
  value = "zabbix"
}
