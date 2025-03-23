resource "aws_db_subnet_group" "main" {
  name       = "rds-subnet-group"
  subnet_ids = [aws_subnet.private_a.id, aws_subnet.private_b.id]

  tags = {
    Name = "Main RDS Subnet Group"
  }
}

resource "aws_security_group" "rds_sg" {
  name        = "rds-sg"
  description = "Allow MySQL access from EC2 backend only"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port                = 3306        # or 5432 for PostgreSQL
    to_port                  = 3306
    protocol                 = "tcp"
    security_groups          = [aws_security_group.ec2_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rds-sg"
  }
}

resource "aws_db_instance" "main" {
  identifier              = "myapp-db"
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  storage_type            = "gp2"
  db_subnet_group_name    = aws_db_subnet_group.main.name
  vpc_security_group_ids  = [aws_security_group.rds_sg.id]
  username                = "root"
  password                = "Ashan1337inupa" 
  publicly_accessible     = false
  skip_final_snapshot     = true

  tags = {
    Name = "myapp-rds"
  }
}
