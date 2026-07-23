# DevOps CI/CD Pipeline

A complete DevOps pipeline for a Node.js application with CI/CD via GitHub Actions and infrastructure as code with Terraform on AWS ECS Fargate.

## Architecture

```
┌──────────────┐     ┌────────────┐     ┌─────────────┐
│  Route53     │────→│  ALB       │────→│  ECS Fargate│
│  app.example │     │  (HTTP/80) │     │  (auto-scale│
│  .com        │     │            │     │   1→3 tasks)│
└──────────────┘     └────────────┘     └─────────────┘
                             │                    │
                     ┌───────┴───────┐    ┌───────┴──────┐
                     │  Security     │    │  VPC         │
                     │  Groups       │    │  (public +   │
                     │  (ALB + ECS)  │    │   private)   │
                     └───────────────┘    └──────────────┘
```

## Project Structure

```
├── .github/workflows/
│   ├── ci-cd.yml        # CI/CD: test → scan → build → deploy
│   ├── infra.yml        # Terraform: plan + apply (infra provis.
│   ├── test.yml         # Reusable: lint + format + test
│   ├── scan.yml         # Reusable: build image + Trivy scan
│   └── build.yml        # Reusable: build & push Docker image
├── src/                 # Node.js Express application
│   ├── index.js         # Entry point
│   ├── server/          # Express server
│   ├── routes/          # API routes
│   └── tests/           # Jest + Supertest
├── terraform/
│   ├── env/             # Root module (backend + variables + outputs)
│   └── modules/         # Terraform modules
│       ├── vpc/         # VPC + subnets + NAT + IGW
│       ├── ecr/         # ECR repository
│       ├── ecs-cluster/ # ECS Fargate cluster
│       ├── ecs-app/     # ECS service + task + auto-scaling
│       ├── alb/         # Application Load Balancer
│       ├── alb-target-group/   # ALB target group
│       ├── alb-listener-rule/  # ALB listener rule
│       ├── route53-hosted-zone/ # Route53 hosted zone
│       └── route53-record/     # Route53 DNS record
└── scripts/
    └── load-test.js     # Load testing script
```

## Prerequisites

- GitHub repository with secrets configured
- AWS account with appropriate IAM permissions
- S3 bucket for Terraform remote state (`aws-terraform-remotebackend`)

### Required GitHub Secrets

| Secret | Description |
|---|---|
| `AWS_ACCESS_KEY_ID` | AWS IAM access key |
| `AWS_SECRET_ACCESS_KEY` | AWS IAM secret key |
| `AWS_ACCOUNT_ID` | AWS account ID (for ECR) |

### Required GitHub Variables

| Variable | Default | Description |
|---|---|---|
| `AWS_REGION` | `ap-southeast-1` | AWS region |
| `WORKING_DIRECTORY` | `src` | App source directory |
| `NODE_VERSION` | `22` | Node.js version |
| `TF_WORKING_DIR` | `terraform/env` | Terraform root module path |
| `TERRAFORM_VERSION` | `1.9.0` | Terraform version |
| `SEVERITY_THRESHOLD` | `HIGH` | Trivy fail threshold (CRITICAL/HIGH) |
| `REGISTRY_TYPE` | `ecr` | Container registry type |

## CI/CD Workflows

### ci-cd.yml – Application CI/CD

| Trigger | Jobs |
|---|---|
| Push `feature/**` | `test` → `scan` |
| Push `main` | `test` → `scan` → `resolve-ecr` → `build-and-push-ecr` → `deploy` |
| PR → `main` | `test` → `scan` |

The `deploy` job runs `terraform apply` with the new image tag, updating the ECS service to rolling-update to the new container image.

### infra.yml – Infrastructure Provisioning

| Trigger | Jobs |
|---|---|
| Push `main` / `infra/**` | `checkov` → `fmt` → `validate` → `plan` → `apply` (main only) |
| PR → `main` | `checkov` → `fmt` → `validate` → `plan` |
| `workflow_dispatch` | Full run |

The `apply` job requires approval via GitHub Environments (`production`).

## Local Development

```bash
# Install dependencies
cd src && npm install

# Run tests
npm test

# Start server
npm start

# Test endpoint
curl localhost:3000
# {"message":"Welcome warriors to Golden Owl - CI/CD Pipeline Demo!"}
```

## Docker

```bash
# Build image
docker build -t goldenowl-app src

# Run container
docker run -p 3000:3000 goldenowl-app
```

The Dockerfile uses a multi-stage build:
1. **Builder stage** – installs all deps, runs tests
2. **Production stage** – copies only production deps, runs as non-root user

## Terraform

### Infrastructure

| Resource | Module |
|---|---|
| VPC | `vpc` |
| ECR Repository | `ecr` |
| ECS Cluster (Fargate) | `ecs-cluster` |
| ECS Service + Task | `ecs-app` |
| Application Load Balancer | `alb` |
| ALB Target Group | `alb-target-group` |
| Route53 Hosted Zone | `route53-hosted-zone` |
| Route53 A Record | `route53-record` |

### Auto-scaling

The ECS service is configured with:
- **Min capacity**: 1 task
- **Max capacity**: 3 tasks
- **Scale-out trigger**: CPU > 70%

### Deploying the infrastructure

```bash
cd terraform/env
terraform init
terraform plan -var="container_image=nginx:latest"
terraform apply -var="container_image=nginx:latest"
```

After the initial deploy, the CI/CD pipeline handles image updates automatically.

## Load Testing

```bash
# Basic (localhost:3000, 10 concurrent, 100 requests)
node scripts/load-test.js

# Custom
node scripts/load-test.js https://app.example.com 50 500
```

Output:
```
Load test: https://app.example.com  |  Concurrency: 50  |  Requests: 500
500/500  |  OK: 500  Failed: 0  |  Avg: 45ms  P95: 82ms  P99: 120ms
```

Run this against the deployed application URL to verify auto-scaling behaviour under load.

## CI/CD Flow Diagram

```
                    ┌──────────────────────────────────────┐
                    │         GitHub Repository             │
                    └──┬────────────────────────┬───────────┘
                       │ push feature/**        │ push main
                       ▼                        ▼
                ┌──────────────┐        ┌──────────────────────┐
                │  featureCI   │        │      mainCI/CD       │
                │  test+scan   │        │ test+scan+build+deploy│
                └──────┬───────┘        └──────────┬───────────┘
                       │                           │
                       ▼                           ▼
                ┌──────────────┐        ┌──────────────────────┐
                │  GitHub      │        │    Amazon ECR        │
                │  Actions     │        │  (push Docker image) │
                └──────────────┘        └──────────┬───────────┘
                                                   │
                                                   ▼
                                        ┌──────────────────────┐
                                        │  Terraform apply      │
                                        │  új ECS service       │
                                        └──────────┬───────────┘
                                                   │
                                                   ▼
                                        ┌──────────────────────┐
                                        │  ECS Fargate         │
                                        │  Rolling update      │
                                        └──────────────────────┘
