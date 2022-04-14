#creating EC2 instance - pasing values diretly 
resource "aws_instance" "defauly-EC2" {
  ami           = var.ec2-ami
  instance_type = "t3.micro"
  subnet_id = "subnet-0801fdc1932b4ae66"
  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name #assigning instance profile to Ec2 machine
  vpc_security_group_ids = ["sg-0b66665ebf99e2b29"]
   key_name = "bastion-key"  # mapping keypair to ec2instance
    tags = {
    Name = "default-EC2"
  }
}

# Creating and Saving Key

resource "tls_private_key" "df-keypair" {
  algorithm = "RSA"
}

resource "aws_key_pair" "df-key" {
  key_name    = "df-key"
  public_key = tls_private_key.df-keypair.public_key_openssh
  }

resource "local_file" "df-private-key" {
  depends_on = [
    tls_private_key.df-keypair
  ]
  content  = tls_private_key.df-keypair.private_key_pem
  filename = "df-key.pem"
}