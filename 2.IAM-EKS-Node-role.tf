resource "aws_iam_role" "EKS-service-role" { #EKS cluster creation role
  name = "EKS-service-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })
  managed_policy_arns = ["arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"]
  }

  resource "aws_iam_role" "Node-service-role" {  #Assign EC2 role for node creation
  name = "Node-service-role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
  # Assign AmazonEKSWorkerNodePolicy, AmazonEC2ContainerRegistryReadOnly,
   #  AmazonEC2ContainerRegistryReadOnly,AmazonEKS_CNI_Policy policies 
  managed_policy_arns = ["arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
                          "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
                           "arn:aws:iam::aws:policy/AmazonSSMFullAccess",
                           "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"]
  }
