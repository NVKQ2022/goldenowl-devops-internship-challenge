resource "aws_lb_target_group" "this" {
  name        = var.name
  vpc_id      = var.vpc_id

  target_type = var.target_type

  port     = var.port
  protocol = var.protocol

  protocol_version              = var.protocol_version
  deregistration_delay          = var.deregistration_delay
  slow_start                    = var.slow_start
  load_balancing_algorithm_type = var.load_balancing_algorithm_type

  health_check {
    enabled             = var.health_check.enabled
    protocol            = var.health_check.protocol
    path                = var.health_check.path
    port                = var.health_check.port
    interval            = var.health_check.interval
    timeout             = var.health_check.timeout
    healthy_threshold   = var.health_check.healthy_threshold
    unhealthy_threshold = var.health_check.unhealthy_threshold
    matcher             = var.health_check.matcher
  }
}