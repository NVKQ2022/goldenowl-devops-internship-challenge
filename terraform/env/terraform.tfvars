region              = "ap-southeast-1"
project_name        = "goldenowl-app"
ecr_repository_name = "goldenowl-app"
container_port      = 3000
container_image     = "nginx:latest"
cpu                 = 256
memory              = 512
desired_count       = 1


vpc_cidr             = "10.0.0.0/16"
public_subnets       = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnets      = ["10.0.10.0/24", "10.0.11.0/24"]
availability_zones   = ["ap-southeast-1a", "ap-southeast-1b"]
nat_gateway_count    = 0
enable_vpc_endpoints = true