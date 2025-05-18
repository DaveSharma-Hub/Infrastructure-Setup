output "ecs_service_dns" {
  description = "Public DNS name of the ECS load balancer"
  value       = aws_lb.ecs_alb.dns_name
}