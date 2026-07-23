variable "name" {
  description = "Application name."
  type        = string
}

variable "cluster_arn" {
  description = "ARN of the ECS cluster."
  type        = string
}

variable "container_image" {
  description = "Container image."
  type        = string
}

variable "container_port" {
  description = "Container port."
  type        = number
}

variable "cpu" {
  type    = number
  default = 256
}

variable "memory" {
  type    = number
  default = 512
}

variable "desired_count" {
  type    = number
  default = 1
}

variable "subnet_ids" {
  type = list(string)
}

variable "security_group_ids" {
  type = list(string)
}

variable "assign_public_ip" {
  type    = bool
  default = false
}

variable "cluster_name" {
  description = "Name of the ECS cluster (needed for auto-scaling resource ID)."
  type        = string
  default     = null
}

variable "target_group_arn" {
  description = "ARN of the ALB target group for load balancer integration."
  type        = string
  default     = null
}

variable "enable_autoscaling" {
  description = "Enable Application Auto Scaling for the ECS service."
  type        = bool
  default     = false
}

variable "min_capacity" {
  description = "Minimum number of tasks."
  type        = number
  default     = 1
}

variable "max_capacity" {
  description = "Maximum number of tasks."
  type        = number
  default     = 3
}

variable "cpu_target_value" {
  description = "Target CPU utilization percentage for auto-scaling."
  type        = number
  default     = 70
}