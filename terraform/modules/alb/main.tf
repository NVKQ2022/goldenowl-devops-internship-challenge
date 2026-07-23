resource "aws_lb" "this" {
  name               = var.name
  load_balancer_type = "application"

  internal        = var.internal
  security_groups = var.security_group_ids
  subnets         = var.subnet_ids

  idle_timeout               = var.idle_timeout
  enable_deletion_protection = var.deletion_protection
}

################################################################################
# HTTP
################################################################################

resource "aws_lb_listener" "http" {
  count = var.enable_http ? 1 : 0

  load_balancer_arn = aws_lb.this.arn
  port              = var.http_port
  protocol          = "HTTP"

  dynamic "default_action" {

    for_each = var.http_redirect_to_https ? [1] : []

    content {
      type = "redirect"

      redirect {
        port        = tostring(var.https_port)
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    }
  }

  dynamic "default_action" {

    for_each = var.http_redirect_to_https ? [] : [1]

    content {
      type = "fixed-response"

      fixed_response {
        status_code  = "404"
        content_type = "text/plain"
        message_body = "No target group configured."
      }
    }
  }
}

################################################################################
# HTTPS
################################################################################

resource "aws_lb_listener" "https" {
  count = var.enable_https ? 1 : 0

  load_balancer_arn = aws_lb.this.arn

  port     = var.https_port
  protocol = "HTTPS"

  ssl_policy      = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn = var.certificate_arn

  default_action {
    type = "fixed-response"

    fixed_response {
      status_code  = "404"
      content_type = "text/plain"
      message_body = "No target group configured."
    }
  }
}