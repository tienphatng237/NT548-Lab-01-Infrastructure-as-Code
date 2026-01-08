resource "aws_route_table" "this" { vpc_id = var.vpc_id }

resource "aws_route" "internet" {
  route_table_id = aws_route_table.this.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = var.gateway_id
}

resource "aws_route_table_association" "assoc" {
  subnet_id = var.subnet_id
  route_table_id = aws_route_table.this.id
}