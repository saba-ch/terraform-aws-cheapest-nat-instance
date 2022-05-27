resource "aws_network_interface" "main" {
  count = local.create_nat ? 1 : 0

  subnet_id = var.public_subnet_id
  source_dest_check = false
  security_groups = [aws_security_group.main[0].id]

  tags = merge(
    var.tags,
    {
      Name = "${var.prefix}_nat_instance_interface"
    }
  )
}

resource "aws_eip" "main" {
  count = local.create_nat ? 1 : 0

  vpc = true

  tags = merge(
    var.tags,
    {
      Name = "${var.prefix}_nat_instance_eip"
    }
  )
}

resource "aws_eip_association" "main" {
  count = local.create_nat ? 1 : 0

  network_interface_id = aws_network_interface.main[0].id
  allocation_id        = aws_eip.main[0].id
}

resource "aws_security_group" "main" {
  count = local.create_nat ? 1 : 0
  
  name        = "${var.prefix}-nat-sg"
  vpc_id      = var.vpc_id

  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = var.private_subnets
    self             = false
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.prefix}-nat-sg"
    }
  )
}
