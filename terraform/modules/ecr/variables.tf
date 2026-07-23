variable "name" {
  description = "The name of the ECR repository."
  type        = string
}

variable "image_tag_mutability" {
  description = "The tag mutability setting for the ECR repository. Valid values are 'MUTABLE' or 'IMMUTABLE'."
  type        = string
  default     = "MUTABLE"
}

variable "scan_on_push" {
  description = "Whether to scan images on push to the ECR repository."
  type        = bool
  default     = false
}