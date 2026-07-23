variable "zone_id" {
  description = "Hosted zone ID."
  type        = string
}

variable "name" {
  description = "Record name."
  type        = string
}

variable "type" {
  description = "Record type."
  type        = string
}

variable "ttl" {
  description = "TTL."
  type        = number
  default     = 300
}

variable "records" {
  description = "Record values."
  type        = list(string)
  default     = []
}

variable "alias" {
  description = "Alias record configuration."

  type = object({
    name                   = string
    zone_id                = string
    evaluate_target_health = optional(bool, false)
  })

  default = null
}