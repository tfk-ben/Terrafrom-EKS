provider "kubernetes" {
    host = data.aws_eks_cluster.myapp-cluster.endpoint #end point of the cluster 
    token = data.aws_eks_cluster_auth.myapp-cluster.token
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.myapp-cluster.certificate_authority.0.data)
}


#data
data "aws_eks_cluster" "myapp-cluster" {
    name = module.eks.cluster_id
}

#for token 
data "aws_eks_cluster_auth" "myapp-cluster" {
    name = module.eks.cluster_id
}


module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "17.10.0"

  cluster_name = "myapp-eks-cluster"   # name same one in tags  
  cluster_version = "1.22"

  subnets = module.my-vpc.private_subnets # where we put worker nodes / we chose private subnets 
  vpc_id = module.my-vpc.vpc_id

  tags = {
    environment = "development"
    application = "myapp"
  }

# worker nodee 

worker_groups = [
    {
        instance_type = "t2.small"
        name = "worker-group-1"
        asg_desired_capacity = 2
    },
    {
        instance_type = "t2.medium"
        name = "worker-group-2"
        asg_desired_capacity = 1
    }  
]


}


