resource "aws_eks_node_group" "EKS-Nodes" {
  cluster_name    = aws_eks_cluster.EKS-Cluster.name
  node_group_name = "EKS-Nodes"
  node_role_arn   = aws_iam_role.Node-service-role.arn
  subnet_ids      = [aws_subnet.publicsubnets.id, aws_subnet.publicsubnetstwo.id]
  

  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }

 /*  depends_on = [   #as we are using AWS managed policies below custom manageed policies are not required. 
    aws_iam_role_policy_attachment.example-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.example-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.example-AmazonEC2ContainerRegistryReadOnly,
  ] */
}
