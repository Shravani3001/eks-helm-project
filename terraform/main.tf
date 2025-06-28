module "vpc" {
    source = "terraform-aws-modules/vpc/aws"
    version = "3.19.0"

    name = "eks-vpc"
    cidr = "10.0.0.0/16"

    azs = ["us-east-1a", "us-east-1b", "us-east-1c"]
    public_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
    private_subnets = ["10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24"]

    enable_nat_gateway = true
    single_nat_gateway = true
}

module "eks" {
    source = "terraform-aws-modules/eks/aws"
    version = "19.9.0"

    cluster_name = var.cluster_name
    cluster_version = "1.27"

    cluster_endpoint_public_access = true
    cluster_endpoint_private_access = true

    subnet_ids = module.vpc.private_subnets
    vpc_id = module.vpc.vpc_id

    manage_aws_auth_configmap = true

    eks_managed_node_groups = {
        eks_nodes = {
             instance_type = var.instance_type
             desired_capacity = var.desired_capacity
             max_size = var.max_size
             min_size = var.min_size
        }
    }
}
