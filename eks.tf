module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~>20.0"

  cluster_name    = "${var.name}-eks"
  cluster_version = "1.29"

  vpc_id     = aws_vpc.plate.id
  subnet_ids = aws_subnet.public[*].id

  # 실습 환경에서만 Public Endpoint 허용
  cluster_endpoint_public_access           = true
  enable_cluster_creator_admin_permissions = true

  eks_managed_node_groups = {
    default = {
      instance_types = var.node_instance_types
      min_size       = 1
      max_size       = 2
      desired_size   = 1

      subnet_ids = aws_subnet.public[*].id
    }
  }

  tags = {
    Name = "${var.name}-eks"
  }
}

data "aws_eks_cluster" "this" {
  name       = module.eks.cluster_name
  depends_on = [module.eks]
}

data "aws_eks_cluster_auth" "this" {
  name       = module.eks.cluster_name
  depends_on = [module.eks]
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.this.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.this.token
}