provider "aws" {
  region = "ap-south-1"
}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  token                  = data.aws_eks_cluster_auth.cluster.token
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_name
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
