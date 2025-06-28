variable "region" {
    default = "us-east-1"
}

variable "instance_type" {
    default = "t2.micro"
}

variable "desired_capacity" {
    default = 2
}

variable "max_size" {
    default = 3
}

variable "min_size" {
    default = 1
}

variable "cluster_name" {
    default = "eks-cluster"
}

variable "node_group_name" {
    default = "eks-nodes"
}