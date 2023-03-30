resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr_block
  tags = merge(
    {
      Name = "vpc-${var.project_name}"
    },
    var.cz_tags,
  )
}

resource "aws_subnet" "public" {
    count = length(var.public_subnet_cidr_block)
    vpc_id = aws_vpc.vpc.id
    cidr_block = var.public_subnet_cidr_block[count.index]
    availability_zone = var.avail_zones[count.index]
      tags = merge(
    {
      Name = "public-${substr("${var.avail_zones[count.index]}", -1, 1)}-${count.index}-${var.project_name}"
    },
    var.cz_tags,
  )
}

resource "aws_subnet" "private" {
    count = length(var.private_subnet_cidr_block)
    vpc_id = aws_vpc.vpc.id
    cidr_block = var.private_subnet_cidr_block[count.index]
    availability_zone = var.avail_zones[count.index]
      tags = merge(
    {
      Name = "private-${substr("${var.avail_zones[count.index]}", -1, 1)}-${count.index}-${var.project_name}"
    },
    var.cz_tags,
  )
}

resource "aws_default_network_acl" "vpc_network_acl" {
  default_network_acl_id = aws_vpc.vpc.default_network_acl_id

  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  ingress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = merge(
    {
      Name = "nacl_${var.project_name}"
    },
    var.cz_tags,
  )
}

resource "aws_default_security_group" "default_sg" {
  vpc_id = aws_vpc.vpc.id

  ingress {
    protocol    = "tcp"
    from_port   = 0
    to_port     = 65535
    cidr_blocks = [aws_vpc.vpc.cidr_block]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    {
      Name        = "default_sg_${var.project_name}"
      Description = "default security group"
    },
    var.cz_tags,
  )
}
