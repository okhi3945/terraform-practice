provider "aws" {
  region  = "ap-northeast-2"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.17.0"

  name = "eks-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["ap-northeast-2a", "ap-northeast-2b", "ap-northeast-2c", "ap-northeast-2d"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false # 1개의 NAT 게이트웨이 설정
  
  map_public_ip_on_launch = true

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}


module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.31"  

  cluster_name    = "test-cluster"
  cluster_version = "1.31"

  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.public_subnets  # public 서브넷만 사용

  cluster_endpoint_public_access = true
  enable_cluster_creator_admin_permissions = true

  cluster_compute_config = {
    enabled = true
    node_pools = ["general-purpose"]
  }

  cluster_addons = {
    coredns = {
    }
    kube-proxy = {
    }
    vpc-cni = {
    }
    eks-pod-identity-agent = {
    }
  }

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
