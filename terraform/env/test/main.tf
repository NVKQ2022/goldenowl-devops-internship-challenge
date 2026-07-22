module "ecr" {
  source = "../../modules/ecr"

  name       = var.ecr_repository_name
  scan_on_push = true
}

output "ecr_repository_url" {
  description = "URL of the ECR repository"
  value       = module.ecr.repository_url
}
