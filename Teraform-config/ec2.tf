resource "aws_key_pair" "deployer" {
  key_name   = "backend-key"
  public_key = file("~/.ssh/id_ed25519.pub") 
}


resource "aws_instance" "backend" {
  ami                         = "ami-08c40ec9ead489470"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.private_a.id
  key_name                    = aws_key_pair.deployer.key_name
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]
  associate_public_ip_address = false 

  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update -y
              sudo apt-get install -y docker.io
              sudo systemctl start docker
              sudo systemctl enable docker

              sudo usermod -aG docker ubuntu

              # Run Docker container with correct environment variables
              docker run -d -p 3000:3000 \
                -e DB_HOST=myapp-db.c4skp9zvnt3k.us-east-1.rds.amazonaws.com \
                -e DB_PORT=3306 \
                -e DB_USER=root \
                -e DB_PASSWORD=Ashan1337inupa\
                -e DB_NAME=product_catalog \
                --name backend-app \
                ashan352/to-app-aws-backend
EOF

  tags = {
    Name = "Backend-Server"
  }
}

resource "aws_security_group" "alb_sg" {
  name   = "alb-sg"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb-sg"
  }
}

resource "aws_security_group_rule" "allow_alb_to_backend" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.ec2_sg.id
  source_security_group_id = aws_security_group.alb_sg.id
}












