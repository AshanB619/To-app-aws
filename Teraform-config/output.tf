output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_id" {
  value = aws_subnet.public.id
  
}

output "private_subnet_id" {
  value = aws_subnet.private_a.id
}

output "rds_endpoint" {
  value = aws_db_instance.main.endpoint
}

