resource "aws_ecs_cluster" "main" {
  name = "${var.server_name}-cluster"
}

resource "aws_ecs_task_definition" "main-task-definition" {
  family                   = "ecs-server-task"
  cpu                      = "256"
  memory                   = "512"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn

  container_definitions = jsonencode([
    {
      name      = var.server_name
      image     = var.image_tag
      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = var.container_port
          protocol      = "tcp"
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "ecs-service" {
  name            = "${var.server_name}-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.main-task-definition.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    subnets         = aws_subnet.subnet.id
    assign_public_ip = true
    security_groups = [aws_security_group.ecs_sg.id]
  }

   load_balancer {
    target_group_arn = aws_lb_target_group.ecs_tg.arn
    container_name   = "app"
    container_port   = var.container_port
  }

  depends_on = [aws_lb_listener.ecs_listener]
}
