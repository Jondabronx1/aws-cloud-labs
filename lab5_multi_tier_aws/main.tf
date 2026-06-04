# Terraform settings block
terraform {
  # Required providers Terraform must download
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>5.0"
    }
  }
}

#this is the provider that i am using, as well as using a variable for region instead of hardcoding.
provider "aws" {
  region = var.aws_region
}

# vpc configuration, that creates a isolated network environment for 3_tier application
resource "aws_vpc" "my_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true


  tags = {
    Name = "multi-tier-app"
  }
}

# 
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name = "name"
    # Filter to find Amazon Linux 2, HVM virtualization, EBS-backed, x86_64 architecture
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

}

# creates the public subnet
resource "aws_subnet" "public_subnets" {
  for_each = var.public_subnets

  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = each.value
  availability_zone       = each.key
  map_public_ip_on_launch = true
}

# creates the private subnet
resource "aws_subnet" "private_subnets" {
  for_each = var.private_subnets

  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = each.value
  availability_zone       = each.key
  map_public_ip_on_launch = false
}

# create internet gateway. this is the bridge connect from my vpc to the internet
resource "aws_internet_gateway" "my_ig" {
  vpc_id = aws_vpc.my_vpc.id

}

#Sends all outbound internet traffic to Internet Gateway. this is used by public subnets(alb & NAT gateway)
resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_ig.id
  }

}

# create a route for the private subnet.sends outbound internet traffic to NAT Gateway
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ng.id
  }

}

# associate route table with private subnet
resource "aws_route_table_association" "my_private_assoc" {
  for_each       = aws_subnet.private_subnets
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private_rt.id

}
# associate route table with public subnet
resource "aws_route_table_association" "my_public_assoc" {
  for_each       = aws_subnet.public_subnets
  subnet_id      = each.value.id
  route_table_id = aws_route_table.rt.id
}

# creates the NAT gateway, along a elastic ip to give the NAT gateway a public face. 
# must go in one public subnet
resource "aws_eip" "nat_gw_ip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "ng" {
  allocation_id = aws_eip.nat_gw_ip.id
  subnet_id     = values(aws_subnet.public_subnets)[0].id
}

# create ec2 instances
resource "aws_instance" "my_app" {
  for_each               = aws_subnet.private_subnets
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = each.value.id
  vpc_security_group_ids = [aws_security_group.app_sg.id]


  # script will run when server starts; this is for bootstrapping
  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install httpd -y
              systemctl start httpd
              systemctl enable httpd
              echo "Hello from Terraform EC2 instance" > /var/www/html/index.html
              EOF

  # unique server nam
  tags = {
    name = "my-app-server${each.key}"
  }
}
# this is a security group for my ec2 instances that holds my app
resource "aws_security_group" "app_sg" {
  name   = "app-sg"
  vpc_id = aws_vpc.my_vpc.id

  # allow  in http traffic only application load balencer
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }
  # allow in ssh from ip
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

# security group for load balencer; allow traffic from public internet, as well as traffic going out
resource "aws_security_group" "alb_sg" {
  name   = "alb_sg"
  vpc_id = aws_vpc.my_vpc.id

  ingress {
    description = "HTTP from internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# create load balancer in order to distribute traffic
resource "aws_lb" "app_lb" {
  name               = "app-lb"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [for s in aws_subnet.public_subnets : s.id]


}

# create load balencer listner in order to to be trigger by the traffic coming and then proceeds to send it out.
# Application Load Balancer Listener
# Listens for incoming HTTP traffic on port 80
# When traffic arrives, it forwards requests to the target group
resource "aws_lb_listener" "http_listener" {

  # ARN of the Application Load Balancer
  load_balancer_arn = aws_lb.app_lb.arn

  # Port the ALB will listen on
  port     = 80
  protocol = "HTTP"

  # Defines what action to take when traffic is received
  default_action {

    # Forward traffic to target group (EC2 instances)
    type = "forward"

    # Target group that contains the application EC2 instances
    target_group_arn = aws_lb_target_group.my_tg.arn
  }
}


# target group that tells the load balencer where to send the traffic
resource "aws_lb_target_group" "my_tg" {
  name     = "web-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.my_vpc.id

}
# target group(tells the load balencer where to send traffic, and attached the instance with)
resource "aws_lb_target_group_attachment" "app_attach" {

  #loops through each ec2 instance in my private subnets 
  for_each = aws_instance.my_app

  target_group_arn = aws_lb_target_group.my_tg.arn
  target_id        = each.value.id
  port             = 80
}

# creates DB subnets(these are isolated database tier)
resource "aws_subnet" "db_subnets" {
  for_each = var.db_subnets

  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = each.value
  availability_zone       = each.key
  map_public_ip_on_launch = false

}

# creates a subnet group, specifically for the the relational database.
# this subnet is where the db will be living. this subnet will be across mutiple az's.
resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "app-db-subnet-group"
  subnet_ids = [for s in aws_subnet.db_subnets_group : s.id]

  tags = {
    name = "db-subnet-group"
  }

}

# creat db subnet groups
resource "aws_db_instance" "my_db" {
  allocated_storage      = 20
  engine                 = "postgres"
  instance_class         = "db.t3.micro"
  db_name                = "mydb"
  username               = var.db_username
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  multi_az               = true
  skip_final_snapshot    = true
  publicly_accessible    = false

}

# creates the security group for DB, that only allows traffic from app
resource "aws_security_group" "db_sg" {
  name        = "db_sg"
  description = "allow database traffic from web tier"
  vpc_id      = aws_vpc.my_vpc.id


  ingress {
    description     = "postgress from app tier"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.app_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

