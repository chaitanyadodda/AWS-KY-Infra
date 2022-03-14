resource "aws_eks_cluster" "EKS-Cluster" {
  name     = "EKS-cluster"
  role_arn = aws_iam_role.EKS-service-role.arn

  vpc_config {
    subnet_ids = [aws_subnet.publicsubnets.id, aws_subnet.publicsubnetstwo.id]
    
  }
  
  #depends_on = [   #as we are using AWS managed policies below custom manageed policies are not required. 
   # aws_iam_role_policy_attachment.example-AmazonEKSClusterPolicy,
    #aws_iam_role_policy_attachment.example-AmazonEKSVPCResourceController,
  #]
}

output "endpoint" {
  value = aws_eks_cluster.EKS-Cluster.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.EKS-Cluster.certificate_authority[0].data
}