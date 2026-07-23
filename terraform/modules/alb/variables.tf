variable "name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "security_group_ids" {
  type = list(string)
}

variable "internal" {
  type    = bool
  default = false
}

variable "enable_http" {
  type    = bool
  default = true
}

variable "enable_https" {
  type    = bool
  default = false
}

variable "certificate_arn" {
  type    = string
  default = null
}

variable "http_port" {
  type    = number
  default = 80
}

variable "https_port" {
  type    = number
  default = 443
}

variable "idle_timeout" {
  type    = number
  default = 60
}

variable "deletion_protection" {
  type    = bool
  default = false
}

variable "http_redirect_to_https" {
  type    = bool
  default = false
}