environment   = "development"
region        = "eu-west-1"
vpc_cidr      = "10.100.0.0/16"
instance_type = "t3.micro"
key_name      = "dev-key"
eks_node_sizes = ["t3.medium", "t3.large"]
eks_version = "1.33"
ecr_names   = ["app", "app2"]