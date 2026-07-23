provider "aws" {
  region = var.region
}

################################################################################
# VPC
################################################################################

module "vpc" {
  source = "../modules/vpc"

  name                 = var.project_name
  cidr                 = var.vpc_cidr
  public_subnets       = var.public_subnets
  private_subnets      = var.private_subnets
  availability_zones   = var.availability_zones
  nat_gateway_count    = var.nat_gateway_count
  enable_vpc_endpoints = var.enable_vpc_endpoints
}

################################################################################
# ECR
################################################################################

module "ecr" {
  source = "../modules/ecr"

  name                 = var.ecr_repository_name
  image_tag_mutability = "MUTABLE"
  scan_on_push         = true
}

################################################################################
# Security Groups
################################################################################

resource "aws_security_group" "alb" {
  name        = "${var.project_name}-alb-sg"
  description = "Security group for the ALB"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "HTTP from internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS from internet"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-alb-sg"
  }
}

resource "aws_security_group" "ecs" {
  name        = "${var.project_name}-ecs-sg"
  description = "Security group for ECS tasks"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description     = "Traffic from ALB"
    from_port       = var.container_port
    to_port         = var.container_port
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-ecs-sg"
  }
}

################################################################################
# ECS Cluster
################################################################################

module "ecs_cluster" {
  source = "../modules/ecs-cluster"

  name                      = "${var.project_name}-cluster"
  enable_container_insights = true
}

################################################################################
# ALB
################################################################################

module "alb_target_group" {
  source = "../modules/alb-target-group"

  name        = "${var.project_name}-tg"
  vpc_id      = module.vpc.vpc_id
  port        = var.container_port
  protocol    = "HTTP"
  target_type = "ip"

  health_check = {
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    matcher             = "200"
    enabled             = true
    interval            = 30
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }
}

module "alb" {
  source = "../modules/alb"

  name               = "${var.project_name}-alb"
  vpc_id             = module.vpc.vpc_id
  subnet_ids         = module.vpc.public_subnet_ids
  security_group_ids = [aws_security_group.alb.id]
  internal           = false
  enable_http        = true
  enable_https       = false
}

module "alb_listener_rule" {
  source = "../modules/alb-listener-rule"

  listener_arn     = module.alb.http_listener_arn
  target_group_arn = module.alb_target_group.arn
  priority         = 1
  path_patterns    = ["/*"]
}

################################################################################
# ECS Service
################################################################################

module "ecs_app" {
  source = "../modules/ecs-app"

  name               = var.project_name
  cluster_arn        = module.ecs_cluster.arn
  cluster_name       = module.ecs_cluster.name
  container_image    = var.container_image
  container_port     = var.container_port
  cpu                = var.cpu
  memory             = var.memory
  desired_count      = var.desired_count
  subnet_ids         = module.vpc.private_subnet_ids
  security_group_ids = [aws_security_group.ecs.id]
  assign_public_ip   = false
  target_group_arn   = module.alb_target_group.arn
  enable_autoscaling = true
  min_capacity       = 1
  max_capacity       = 3
  cpu_target_value   = 70
}

