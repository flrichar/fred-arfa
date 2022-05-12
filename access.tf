## get total subnets for standard nacl

## see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/guides/version-4-upgrade#data-source-aws_subnet_ids for new >4.0 changes

data "aws_subnets" "total" {
  filter {
    name   = "vpc-id"
    values = [aws_vpc.main.id]
  }
  depends_on = [aws_vpc.main]
}

data "aws_subnet" "total" {
  for_each   = toset(data.aws_subnets.total.ids)
  id         = each.value
  depends_on = [aws_vpc.main]
}

resource "aws_network_acl" "main-default" {
  vpc_id = aws_vpc.main.id

  ## standard nacl handles all subnets, ext & int
  subnet_ids = [for s in data.aws_subnet.total : s.id]

  ## all outbound allowed

  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol        = -1
    rule_no         = 101
    action          = "allow"
    ipv6_cidr_block = "::/0"
    from_port       = 0
    to_port         = 0
  }

  ## all dns return traffic

  ingress {
    protocol   = "udp"
    rule_no    = 200
    action     = "allow"
    cidr_block = "9.9.9.9/32"
    from_port  = 0
    to_port    = 65535
  }

  ingress {
    protocol   = "udp"
    rule_no    = 205
    action     = "allow"
    cidr_block = "1.1.1.1/32"
    from_port  = 0
    to_port    = 65535
  }

  ## icmp for v4/v6

  ingress {
    protocol   = "icmp"
    rule_no    = 900
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    icmp_code  = -1
    icmp_type  = -1
    from_port  = 0
    to_port    = 0
  }

  ingress {
    protocol        = "58"
    rule_no         = 910
    action          = "allow"
    ipv6_cidr_block = "::/0"
    icmp_code       = -1
    icmp_type       = -1
    from_port       = 0
    to_port         = 0
  }

  ## v4/v6 ephemeral ports

  ingress {
    protocol        = "udp"
    rule_no         = 996
    action          = "allow"
    ipv6_cidr_block = "::/0"
    from_port       = 1024
    to_port         = 65535
  }

  ingress {
    protocol        = "tcp"
    rule_no         = 997
    action          = "allow"
    ipv6_cidr_block = "::/0"
    from_port       = 1024
    to_port         = 65535
  }

  ingress {
    protocol   = "udp"
    rule_no    = 998
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 999
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }

  ## external trust-nets

  ingress {
    rule_no    = 300
    action     = "allow"
    protocol   = -1
    cidr_block = "PUB-IP-A/32"
    from_port  = 0
    to_port    = 0
  }

  ingress {
    rule_no    = 310
    action     = "allow"
    protocol   = -1
    cidr_block = "PUB-IP-B/32"
    from_port  = 0
    to_port    = 0
  }

  ingress {
    rule_no         = 320
    action          = "allow"
    protocol        = -1
    ipv6_cidr_block = "fc00:0000:0000:0000::/64"
    from_port       = 0
    to_port         = 0
  }

  ## internal trust-nets

  ingress {
    rule_no    = 400
    action     = "allow"
    protocol   = -1
    cidr_block = "10.32.32.0/24"
    from_port  = 0
    to_port    = 0
  }

  ingress {
    rule_no    = 410
    action     = "allow"
    protocol   = -1
    cidr_block = "10.66.96.0/24"
    from_port  = 0
    to_port    = 0
  }

  ingress {
    rule_no    = 420
    action     = "allow"
    protocol   = -1
    cidr_block = "10.66.87.0/24"
    from_port  = 0
    to_port    = 0
  }

  ingress {
    rule_no    = 430
    action     = "allow"
    protocol   = -1
    cidr_block = "172.30.160.0/21"
    from_port  = 0
    to_port    = 0
  }

  tags = merge(local.default_tags,
    {
      Name = "main-default-${local.prefix}"
    }
  )
}

resource "aws_security_group" "trust-services" {
  name        = "trust-services"
  description = "trusted nets/services, secure protocols"
  vpc_id      = aws_vpc.main.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    ipv6_cidr_blocks = ["::/0"]
  }

  ## trust internal nets

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.66.96.0/24", "10.66.87.0/24", "10.32.32.0/24"]
  }

  ## ssh v4/v6, icmpv6

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port        = "-1"
    to_port          = "-1"
    protocol         = "icmpv6"
    ipv6_cidr_blocks = ["::/0"]
  }

  ## wireguard vpn

  ingress {
    from_port   = 7500
    to_port     = 7500
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port        = 7500
    to_port          = 7500
    protocol         = "udp"
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(local.default_tags,
    {
      Name = "trust-services-${local.prefix}"
    }
  )
}

