variable "name" {
  description = "Target group name."
  type        = string
}

variable "vpc_id" {
  description = "VPC ID."
  type        = string
}

variable "port" {
  description = "Target group port."
  type        = number
  default     = 80
}

variable "protocol" {
  description = "Target group protocol."
  type        = string
  default     = "HTTP"

  validation {
    condition = contains([
      "HTTP",
      "HTTPS",
      "TCP",
      "TLS",
      "UDP",
      "TCP_UDP",
      "GENEVE"
    ], var.protocol)

    error_message = "Invalid protocol."
  }
}

variable "target_type" {
  description = "Target type."
  type        = string
  default     = "ip"

  validation {
    condition = contains([
      "instance",
      "ip",
      "lambda",
      "alb"
    ], var.target_type)

    error_message = "Invalid target type."
  }
}

variable "protocol_version" {
  description = "Protocol version."
  type        = string
  default     = "HTTP1"
}

variable "deregistration_delay" {
  description = "Deregistration delay."
  type        = number
  default     = 300
}

variable "slow_start" {
  description = "Slow start duration."
  type        = number
  default     = 0
}

variable "load_balancing_algorithm_type" {
  description = "Load balancing algorithm."
  type        = string
  default     = "round_robin"

  validation {
    condition = contains([
      "round_robin",
      "least_outstanding_requests",
      "weighted_random"
    ], var.load_balancing_algorithm_type)

    error_message = "Invalid load balancing algorithm."
  }
}

variable "health_check" {
  description = "Health check configuration."

  type = object({
    enabled             = optional(bool, true)
    protocol            = optional(string, "HTTP")
    path                = optional(string, "/")
    port                = optional(string, "traffic-port")
    interval            = optional(number, 30)
    timeout             = optional(number, 5)
    healthy_threshold   = optional(number, 5)
    unhealthy_threshold = optional(number, 2)
    matcher             = optional(string, "200")
  })

  default = {}
}