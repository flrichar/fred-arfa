output vpc_id {
  value = aws_vpc.main.id
}

output internal_subnet_ids {
  value = aws_subnet.internal
}

output external_subnet_ids {
  value = aws_subnet.external
}

output external_routes {
  value = aws_route_table.external.route
}

output internal_routes {
  value = aws_route_table.internal.route
}

output subnet_total_ids {
  value = [for s in data.aws_subnet.total : s.id]
}

