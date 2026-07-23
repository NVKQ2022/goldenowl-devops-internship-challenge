terraform {
  backend "s3" {
    bucket = "aws-terraform-remotebackend"
    key    = "tfstate/GOS-devops-challenge.tfstate"
    region = "ap-southeast-1"
  }
}
