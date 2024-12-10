resource "aws_vpc" "tekuchi_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = "tekuchi-contabilidade"
    vpc  = "tekuchi-vpc"
  }
}

resource "aws_internet_gateway" "tekuchi_gateway" {
  vpc_id = aws_vpc.tekuchi_vpc.id

  tags = {
    Name = "tekuchi-gateway"
  }
}

resource "aws_subnet" "tekuchi_public_subnet_a" {
  vpc_id            = aws_vpc.tekuchi_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "tekuchi_public_subnet-a"
  }
  depends_on = [aws_vpc.tekuchi_vpc]
}

resource "aws_subnet" "tekuchi_public_subnet_b" {
  vpc_id            = aws_vpc.tekuchi_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "tekuchi_public_subnet-b"
  }
  depends_on = [aws_vpc.tekuchi_vpc]
}
