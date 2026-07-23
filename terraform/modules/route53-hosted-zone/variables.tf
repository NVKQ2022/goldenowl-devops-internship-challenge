variable "name" {
  description = "Hosted zone domain name."
  type        = string
}

variable "comment" {
  description = "Hosted zone comment."
  type        = string
  default     = null
}

variable "force_destroy" {
  description = "Delete all records when destroying the zone."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags."
  type        = map(string)
  default     = {}
}