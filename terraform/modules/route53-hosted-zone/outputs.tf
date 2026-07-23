output "id" {
  description = "Hosted zone ID."
  value       = aws_route53_zone.this.zone_id
}

output "arn" {
  description = "Hosted zone ARN."
  value       = aws_route53_zone.this.arn
}

output "name" {
  description = "Hosted zone name."
  value       = aws_route53_zone.this.name
}

output "name_servers" {
  description = "Route53 name servers."
  value       = aws_route53_zone.this.name_servers
}