variable "name" {
  description = "Name of the ECS cluster."
  type        = string
}

variable "enable_container_insights" {
  description = "Enable CloudWatch Container Insights."
  type        = bool
  default     = false
}