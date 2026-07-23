output "alb_dns_name" {
  description = "DNS name of the ALB"
  value       = module.alb.dns_name
}

output "ecr_repository_url" {
  description = "URL of the ECR repository"
  value       = module.ecr.repository_url
}

output "ecs_cluster_name" {
  description = "Name of the ECS cluster"
  value       = module.ecs_cluster.name
}

output "ecs_service_name" {
  description = "Name of the ECS service"
  value       = module.ecs_app.service_name
}
