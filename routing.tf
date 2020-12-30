## routing and gateways

## route tables with routes inline

resource "aws_route_table" "external" {
  vpc_id = aws_vpc.main.id

  route {
    ipv6_cidr_block = "::/0"
    ##egress_only_gateway_id = aws_egress_only_internet_gateway.eigw.id
    egress_only_gateway_id = ""
    gateway_id             = aws_internet_gateway.igw.id
  }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  ## ignore importing routes
  lifecycle {
    ignore_changes = [route]
  }

  tags = merge(local.default_tags,
    {
      Name = "external-${local.prefix}"
    }
  )
}

resource "aws_route_table" "internal" {
  vpc_id = aws_vpc.main.id

  route {
    ipv6_cidr_block        = "::/0"
    egress_only_gateway_id = aws_egress_only_internet_gateway.eigw.id
  }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  ## ignore importing routes
  lifecycle {
    ignore_changes = [route]
  }

  tags = merge(local.default_tags,
    {
      Name = "internal-${local.prefix}"
    }
  )
}

## associations

resource "aws_route_table_association" "external" {
  for_each       = aws_subnet.external
  subnet_id      = each.value.id
  route_table_id = aws_route_table.external.id
}

resource "aws_route_table_association" "internal" {
  for_each       = aws_subnet.internal
  subnet_id      = each.value.id
  route_table_id = aws_route_table.internal.id
}

## vpc gateways

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = merge(local.default_tags,
    {
      Name = "${local.prefix}-igw"
    }
  )
}

resource "aws_egress_only_internet_gateway" "eigw" {
  vpc_id = aws_vpc.main.id

  tags = merge(local.default_tags,
    {
      Name = "${local.prefix}-eigw"
    }
  )
}

