output "cluster_name" {
    value = module.eks.cluster_name
}

output "node_group_role_arn" {
    value = module.eks.eks_managed_node_groups["eks_nodes"].iam_role_arn
}

output "cluster_endpoint" {
    value = module.eks.cluster_endpoint
}

output "cluster_security_group_id" {
    value = module.eks.cluster_security_group_id
}