module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.36.0"

  cluster_name = myeks-cluster
  cluster_version = 1.19

  subnet_ids = module.private_subnet_tags
  vpc_id = module.myapp-vpc.vpc-vpc_id

  tags = {
    environment = "Development"
    application = "myapp" 
  }

  eks_managed_node_groups = {
    dev = {  
      min_size = 1
      max_size = 3                                    
      desired_size = 3

      instance_types = ["t2.small"]
    }
}
}