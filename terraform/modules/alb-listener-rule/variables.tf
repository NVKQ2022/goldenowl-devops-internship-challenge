variable "listener_arn" {
  description = "ARN of the listener."
  type        = string
}

variable "target_group_arn" {
  description = "Target group to forward traffic to."
  type        = string
}

variable "priority" {
  description = "Rule priority."
  type        = number
}

variable "host_headers" {
  description = "Host header conditions."
  type        = list(string)
  default     = []
}

variable "path_patterns" {
  description = "Path pattern conditions."
  type        = list(string)
  default     = []
}