terraform{
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "6.6.0"
        }
    }
}

# default vpc 
resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

# default subnet
resource "aws_default_subnet" "default_subnet" {
  availability_zone = "us-east-1a"

  tags = {
    Name = "Default subnet for us-east-1a"
  }
}


# creating security group 
resource "aws_security_group" "tech365-sg" {
  name        = "tech365-sg"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_default_vpc.default.id

  tags = {
    Name = "tech365-sg"
  }
}
# ingress 
resource "aws_vpc_security_group_ingress_rule" "ssh" {
  security_group_id = aws_security_group.tech365-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}
resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group.tech365-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}
resource "aws_vpc_security_group_ingress_rule" "jenkins" {
  security_group_id = aws_security_group.tech365-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 8081
  ip_protocol       = "tcp"
  to_port           = 8081
}
resource "aws_vpc_security_group_ingress_rule" "prometheus" {
  security_group_id = aws_security_group.tech365-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 9090
  ip_protocol       = "tcp"
  to_port           = 9090
}

resource "aws_vpc_security_group_ingress_rule" "grafana" {
  security_group_id = aws_security_group.tech365-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 3000
  ip_protocol       = "tcp"
  to_port           = 3000
}
resource "aws_vpc_security_group_ingress_rule" "app-port" {
  security_group_id = aws_security_group.tech365-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 8080
  ip_protocol       = "tcp"
  to_port           = 8080
}

resource "aws_vpc_security_group_ingress_rule" "node-exporter" {
  security_group_id = aws_security_group.tech365-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 9100
  ip_protocol       = "tcp"
  to_port           = 9100
}

resource "aws_vpc_security_group_ingress_rule" "blackbox-exporter" {
  security_group_id = aws_security_group.tech365-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 9115
  ip_protocol       = "tcp"
  to_port           = 9115
}


resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.tech365-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

# iam role and policy
resource "aws_iam_role" "access_role" {
  name = "access_role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    tag-key = "access_role"
  }
}

# iam profile for the above role
resource "aws_iam_instance_profile" "test_profile" {
  name = "test_profile"
  role = aws_iam_role.access_role.name
}

resource "aws_iam_role_policy" "test_policy" {
  name = "test_policy"
  role = aws_iam_role.access_role.name

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "*"
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}



# create ec2 instance
resource "aws_instance" "webserver" {
  ami           = var.ami
  instance_type = var.instance_type
  associate_public_ip_address = true
  key_name      = var.key_name
  vpc_security_group_ids = [aws_security_group.tech365-sg.id]
  iam_instance_profile = aws_iam_instance_profile.test_profile.name
  user_data = file("script.sh")

   root_block_device {
    volume_size = 25               
    volume_type = "gp2"           
    delete_on_termination = true   
  }
  tags = {
    Name = "Web Server"
  }
}
