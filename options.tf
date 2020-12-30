resource "aws_vpc_dhcp_options" "q9cf" {
  domain_name         = "${local.prefix}.gxize.net"
  domain_name_servers = ["9.9.9.9", "1.1.1.1"]
  ntp_servers         = ["162.159.200.123", "162.159.200.1"]

  tags = merge(local.default_tags,
    {
      Name = "q9cf-${local.prefix}"
    }
  )
}

resource "aws_key_pair" "ssh-key" {
  key_name   = "${local.prefix}-${var.owner}"
  public_key = var.pub_key
}

