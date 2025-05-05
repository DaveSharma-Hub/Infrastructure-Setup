resource "aws_security_group" "ecs_sg" {
  name        = "${var.server_name}-sg"
  description = "Allow inbound HTTP"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "HTTP"
    from_port   = var.container_port
    to_port     = var.container_port
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
    Name = "ecs-${var.server_name}"
  }
}
