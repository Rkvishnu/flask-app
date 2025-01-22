provider "aws" {
  region = "ap-south-1"
}

locals {
  region         = "ap-south-1"
  name           = "flask-app-cluster"
  vpc_cidr       = "10.123.0.0/16"
  azs            = ["ap-south-1a", "ap-south-1b"]
  public_subnets = ["10.123.1.0/24", "10.123.2.0/24"]
  private_subnets = ["10.123.3.0/24", "10.123.4.0/24"]
  tags = {
    Name = "flask-app-cluster"
  }
}
