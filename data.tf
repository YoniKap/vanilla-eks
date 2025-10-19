data "aws_availability_zones" "azs" {
  state = "available"
}

data "aws_eks_cluster_auth" "cluster" {
  name       = module.eks.cluster_name
  depends_on = [module.eks.cluster_arn]
}