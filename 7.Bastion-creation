resource "aws_security_group" "ec2bastion-sg" {
  name        = "SG-bastion-cluster"
  vpc_id      = aws_vpc.vpc.id
  
   # Egress allows Outbound traffic from the bastion to the  Internet over 22 port

  egress {                   # Outbound Rule
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
     # Ingress allows Inbound traffic to bastion from the  Internet 

  ingress {                  # Inbound Rule
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ssh-bastion"
  }
}
#creating EC2 instance 
resource "aws_instance" "bastion-ec2" {
  ami           = var.ec2-ami
  instance_type = "t3.micro"
  subnet_id = aws_subnet.publicsubnets.id
  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name #assigning instance profile to Ec2 machine
  vpc_security_group_ids = [aws_security_group.ec2bastion-sg.id]
  key_name = "bastion-key"  # mapping keypair to ec2instance
  depends_on = [
    aws_security_group.ec2bastion-sg
  ]
  tags = {
    Name = "bastion-ec2"
  }
}

# Creating and Saving Key

resource "tls_private_key" "keypair" {
  algorithm = "RSA"
}

resource "aws_key_pair" "bastion-key" {
  key_name    = "bastion-key"
  public_key = tls_private_key.keypair.public_key_openssh
  }

resource "local_file" "private_key" {
  depends_on = [
    tls_private_key.keypair
  ]
  content  = tls_private_key.keypair.private_key_pem
  filename = "bastion-key.pem"
}




