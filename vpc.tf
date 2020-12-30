## vpc

resource "aws_vpc" "main" {
  cidr_block                       = var.vpc_cidr
  enable_dns_support               = true
  enable_dns_hostnames             = false
  assign_generated_ipv6_cidr_block = true

  tags = local.default_tags
}

## internal subnet

resource "aws_subnet" "internal" {
  for_each = var.internal_subnet

  vpc_id                          = aws_vpc.main.id
  cidr_block                      = each.value.cidr
  ipv6_cidr_block                 = cidrsubnet(aws_vpc.main.ipv6_cidr_block, 8, each.value.cidr6)
  availability_zone               = each.value.zone
  map_public_ip_on_launch         = false
  assign_ipv6_address_on_creation = true

  ## ignore importing v6 cidr
  ##  lifecycle {
  ##    ignore_changes = [ipv6_cidr_block]
  ##  }

  tags = merge(local.default_tags,
    {
      Name = "${local.prefix}-${each.key}"
    }
  )
}

## external subnet

resource "aws_subnet" "external" {
  for_each = var.external_subnet

  vpc_id                          = aws_vpc.main.id
  cidr_block                      = each.value.cidr
  ipv6_cidr_block                 = cidrsubnet(aws_vpc.main.ipv6_cidr_block, 8, each.value.cidr6)
  availability_zone               = each.value.zone
  map_public_ip_on_launch         = true
  assign_ipv6_address_on_creation = true

  ## ignore importing v6 cidr
  ##  lifecycle {
  ##    ignore_changes = [ipv6_cidr_block]
  ##  }

  tags = merge(local.default_tags,
    {
      Name = "${local.prefix}-${each.key}"
    }
  )
}

