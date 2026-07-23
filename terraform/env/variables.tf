variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-southeast-1"
}

variable "project_name" {
  description = "Name prefix for all resources"
  type        = string
}

variable "ecr_repository_name" {
  description = "Name of the ECR repository"
  type        = string
}

variable "container_port" {
  description = "Port the container listens on"
  type        = number
  default     = 3000
}

variable "container_image" {
  description = "Container image URL (placeholder for first deploy, replaced by CI later)"
  type        = string
}

variable "cpu" {
  description = "CPU units for the Fargate task (256 = 0.25 vCPU)"
  type        = number
  default     = 256
}

variable "memory" {
  description = "Memory for the Fargate task (MiB)"
  type        = number
  default     = 512
}

variable "desired_count" {
  description = "Desired number of ECS tasks"
  type        = number
  default     = 1
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnets" {
  description = "Public subnet CIDR blocks"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets" {
  description = "Private subnet CIDR blocks"
  type        = list(string)
  default     = ["10.0.10.0/24", "10.0.11.0/24"]
}

variable "availability_zones" {
  description = "Availability zones"
  type        = list(string)
  default     = ["ap-southeast-1a", "ap-southeast-1b"]
}

variable "nat_gateway_count" {
  description = "Number of NAT gateways (0 = none)"
  type        = number
  default     = 0
}

variable "enable_vpc_endpoints" {
  description = "Create VPC endpoints for ECR, S3, and CloudWatch Logs"
  type        = bool
  default     = true
}

variable "domain_name" {
  description = "Domain name for Route53 hosted zone (e.g., example.com)"
  type        = string
}

variable "subdomain" {
  description = "Subdomain prefix (e.g., app → app.example.com)"
  type        = string
  default     = "app"
}