
# VPC
############################
resource "aws_vpc" "three_tier_vpc" {
  cidr_block = "10.1.0.0/16"

  tags = {
    Name = "three-tier-vpc"
  }
}


# Subnets
############################
resource "aws_subnet" "public_1" {
  vpc_id                  = aws_vpc.three_tier_vpc.id
  cidr_block              = "10.1.0.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = { Name = "public-1" }
}

resource "aws_subnet" "public_2" {
  vpc_id                  = aws_vpc.three_tier_vpc.id
  cidr_block              = "10.1.1.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = { Name = "public-2" }
}

resource "aws_subnet" "frontend_1" {
  vpc_id            = aws_vpc.three_tier_vpc.id
  cidr_block        = "10.1.2.0/24"
  availability_zone = "us-east-1a"

  tags = { Name = "frontend-1" }
}

resource "aws_subnet" "frontend_2" {
  vpc_id            = aws_vpc.three_tier_vpc.id
  cidr_block        = "10.1.3.0/24"
  availability_zone = "us-east-1b"

  tags = { Name = "frontend-2" }
}

resource "aws_subnet" "backend_1" {
  vpc_id            = aws_vpc.three_tier_vpc.id
  cidr_block        = "10.1.4.0/24"
  availability_zone = "us-east-1a"

  tags = { Name = "backend-1" }
}

resource "aws_subnet" "backend_2" {
  vpc_id            = aws_vpc.three_tier_vpc.id
  cidr_block        = "10.1.5.0/24"
  availability_zone = "us-east-1b"

  tags = { Name = "backend-2" }
}

resource "aws_subnet" "rds_1" {
  vpc_id            = aws_vpc.three_tier_vpc.id
  cidr_block        = "10.1.6.0/24"
  availability_zone = "us-east-1a"

  tags = { Name = "rds-1" }
}

resource "aws_subnet" "rds_2" {
  vpc_id            = aws_vpc.three_tier_vpc.id
  cidr_block        = "10.1.7.0/24"
  availability_zone = "us-east-1b"

  tags = { Name = "rds-2" }
}


# IGW & NAT
############################
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.three_tier_vpc.id
}

resource "aws_eip" "nat_eip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_1.id
}


# Route Tables
############################
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.three_tier_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.three_tier_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }
}

resource "aws_route_table_association" "public_assoc_1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_assoc_2" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "private_assoc" {
  for_each = {
    f1 = aws_subnet.frontend_1.id
    f2 = aws_subnet.frontend_2.id
    b1 = aws_subnet.backend_1.id
    b2 = aws_subnet.backend_2.id
    r1 = aws_subnet.rds_1.id
    r2 = aws_subnet.rds_2.id
  }

  subnet_id      = each.value
  route_table_id = aws_route_table.private_rt.id
}


# Security Groups
############################
resource "aws_security_group" "alb_public_sg" {
  name   = "alb-public-sg"
  vpc_id = aws_vpc.three_tier_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
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

resource "aws_security_group" "frontend_sg" {
  name   = "frontend-sg"
  vpc_id = aws_vpc.three_tier_vpc.id
}

resource "aws_security_group_rule" "frontend_http" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.frontend_sg.id
  source_security_group_id = aws_security_group.alb_public_sg.id
}

resource "aws_security_group_rule" "frontend_https" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.frontend_sg.id
  source_security_group_id = aws_security_group.alb_public_sg.id
}

resource "aws_security_group_rule" "frontend_egress_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.frontend_sg.id
}


resource "aws_security_group" "backend_sg" {
  name   = "backend-sg"
  vpc_id = aws_vpc.three_tier_vpc.id
}

resource "aws_security_group_rule" "backend_http" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.backend_sg.id
  source_security_group_id = aws_security_group.frontend_sg.id
}

resource "aws_security_group_rule" "backend_egress_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.backend_sg.id
}


resource "aws_security_group" "rds_sg" {
  name   = "rds-sg"
  vpc_id = aws_vpc.three_tier_vpc.id
}

resource "aws_security_group_rule" "rds_mysql" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = aws_security_group.rds_sg.id
  source_security_group_id = aws_security_group.backend_sg.id
}

resource "aws_security_group_rule" "rds_egress_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.rds_sg.id
}



# RDS
############################
resource "aws_db_subnet_group" "rds_subnet_grp" {
  name       = "rds-subnet-group"
  subnet_ids = [aws_subnet.rds_1.id, aws_subnet.rds_2.id]
}

resource "aws_db_instance" "mysql_db" {
  identifier           = "threetier-db"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  allocated_storage    = 10
  username             = "admin"
  password             = "Admin@123"
  db_subnet_group_name = aws_db_subnet_group.rds_subnet_grp.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  skip_final_snapshot  = true
}
