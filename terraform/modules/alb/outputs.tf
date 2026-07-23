output "id" {
  value = aws_lb.this.id
}

output "arn" {
  value = aws_lb.this.arn
}

output "dns_name" {
  value = aws_lb.this.dns_name
}

output "zone_id" {
  value = aws_lb.this.zone_id
}

output "http_listener_arn" {
  value = try(aws_lb_listener.http[0].arn, null)
}

output "https_listener_arn" {
  value = try(aws_lb_listener.https[0].arn, null)
}