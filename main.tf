provider "aws" {

  region = var.aws_region

}


resource "aws_vpc" "main" {

  cidr_block = var.vpc_cidr

  enable_dns_hostnames = true

  enable_dns_support = true


  tags = {

    Name = "${var.project_name}-vpc"

  }

}

resource "aws_internet_gateway" "main" {

  vpc_id = aws_vpc.main.id


  tags = {

    Name = "${var.project_name}-igw"

  }

}

resource "aws_subnet" "public" {

  count = length(var.public_subnet_cidrs)

  vpc_id = aws_vpc.main.id

  cidr_block = var.public_subnet_cidrs[count.index]

  availability_zone = var.availability_zones[count.index]


  map_public_ip_on_launch = true


  tags = {

    Name = "${var.project_name}-public-subnet-${count.index + 1}"

  }
}

resource "aws_subnet" "private" {

  count = length(var.private_subnet_cidrs)

  vpc_id = aws_vpc.main.id

  cidr_block = var.private_subnet_cidrs[count.index]

  availability_zone = var.availability_zones[count.index]


  tags = {

    Name = "${var.project_name}-private-subnet-${count.index + 1}"

  }

}

resource "aws_route_table" "public" {

  vpc_id = aws_vpc.main.id


  route {

    cidr_block = "0.0.0.0/0"

    gateway_id = aws_internet_gateway.main.id

  }


  tags = {

    Name = "${var.project_name}-public-rt"

  }

}

resource "aws_route_table" "private" {

  vpc_id = aws_vpc.main.id


  tags = {

    Name = "${var.project_name}-private-rt"

  }

}


resource "aws_route_table_association" "public" {

  count = length(var.public_subnet_cidrs)

  subnet_id = aws_subnet.public[count.index].id

  route_table_id = aws_route_table.public.id

}


resource "aws_route_table_association" "private" {

  count = length(var.private_subnet_cidrs)

  subnet_id = aws_subnet.private[count.index].id

  route_table_id = aws_route_table.private.id

}

resource "aws_security_group" "web" {

  name = "${var.project_name}-web-sg"

  description = "Security group for web servers"

  vpc_id = aws_vpc.main.id


  ingress {

    from_port = 80

    to_port = 80

    protocol = "tcp"

    cidr_blocks = ["0.0.0.0/0"]

  }


  egress {

    from_port = 0

    to_port = 0

    protocol = "-1"

    cidr_blocks = ["0.0.0.0/0"]

  }


  tags = {

    Name = "${var.project_name}-web-sg"

  }

}

resource "aws_instance" "web" {

  ami = var.instance_ami

  instance_type = var.instance_type

  subnet_id = aws_subnet.public[0].id


  vpc_security_group_ids = [aws_security_group.web.id]


  tags = {

    Name = "${var.project_name}-web-server"

  }

}

