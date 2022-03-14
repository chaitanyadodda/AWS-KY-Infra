#An instance profile is a container for an IAM role that 
#you can use to pass role information to an EC2 instance when the instance starts.
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ec2_instance_profile"
  role = aws_iam_role.ec2-ssm-role.name   #assigning role with SSM permissions. refer below resouce for role creation
}

resource "aws_iam_role" "ec2-ssm-role" {
  name = "ec2-ssm-role"
   managed_policy_arns = ["arn:aws:iam::aws:policy/AmazonSSMFullAccess"] #get relavant arn from policies in AWS console 

  assume_role_policy = jsonencode(
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"   #assigning ec2 trust relation
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
  )
}

#creating security group 
resource "aws_security_group" "ec2-security-grp" {
  name        = "ec2-security-grp"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 0    #mention port 443 if traffic needs to tram=nsmit from 443 port
    to_port          = 0
    protocol         = "-1"
    #cidr_blocks      = [aws_vpc.vpc.cidr_block]  # allow traffic from specific IP range
     cidr_blocks      = ["0.0.0.0/0"]   # allows traffic from all Ips
   # ipv6_cidr_blocks = [aws_vpc.vpcid.ipv6_cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
   # ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}

#creating EC2 instance 
resource "aws_instance" "Jenkins-EC2" {
  ami           = var.ec2-ami
  instance_type = "t3.micro"
  subnet_id = aws_subnet.publicsubnets.id
  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name #assigning instance profile to Ec2 machine
  vpc_security_group_ids = [aws_security_group.ec2-security-grp.id]
  depends_on = [
    aws_security_group.ec2-security-grp
  ]
  tags = {
    Name = "jenkins-EC2"
  }
}

