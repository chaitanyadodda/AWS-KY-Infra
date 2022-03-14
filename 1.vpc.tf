# Create a VPC
resource "aws_vpc" "vpc" {
  cidr_block = var.cidr-value
  enable_dns_support = true
  enable_dns_hostnames  = true
    tags = {
    Name = "EKS-VPC"
  }
}

resource "aws_security_group" "eks-sg" {
  name        = "SG-eks-cluster"
  vpc_id      = aws_vpc.vpc.id
  
   # Egress allows Outbound traffic from the EKS cluster to the  Internet 

  egress {                   # Outbound Rule
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
     # Ingress allows Inbound traffic to EKS cluster from the  Internet 

  ingress {                  # Inbound Rule
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Creating the EKS cluster


 #Create a Public Subnets.
 resource "aws_subnet" "publicsubnets" {    # Creating Public Subnets
   vpc_id =  aws_vpc.vpc.id
   cidr_block = "${var.publicsubnet}"        # CIDR block of public subnets
   map_public_ip_on_launch = true
   enable_resource_name_dns_a_record_on_launch = true # enabling DNS on launch
 }

 resource "aws_subnet" "publicsubnetstwo" {    # Creating2nd  Public Subnets
   vpc_id =  aws_vpc.vpc.id
   cidr_block = "${var.publicsubnettwo}"        # CIDR block of public subnets
   map_public_ip_on_launch = true
   enable_resource_name_dns_a_record_on_launch = true # enabling DNS on launch
 }

 #Create a Private Subnet                   # Creating Private Subnets
 resource "aws_subnet" "privatesubnets" {
   vpc_id =  aws_vpc.vpc.id
   cidr_block = "${var.privatesubnet}"          # CIDR block of private subnets
   map_public_ip_on_launch = true
   enable_resource_name_dns_a_record_on_launch = true # enabling DNS on launch
 }

#creating Elastic IP for NAT gateway
resource "aws_eip" "NAT" {
   vpc      = true
}
 
#Create NAT Gateway and attach it to publicsubnet - need to create NAT in publicsubnet
 resource"aws_nat_gateway" "NAT" {    # Creating NAT Gateway
        allocation_id = aws_eip.NAT.id
        subnet_id =aws_subnet.publicsubnets.id      # Attaching public subnet to NAT
        depends_on = [   #depends on Elastic IP creation
          aws_eip.NAT
        ]
 }

#Create Internet Gateway and attach it to VPC
 resource "aws_internet_gateway" "IGW" {    # Creating Internet Gateway
    vpc_id =  aws_vpc.vpc.id               # vpc_id will be generated after we create VPC
    }

#Route table for Public Subnet's
 resource "aws_route_table" "PublicRT" {    # Creating RT for Public Subnet, connect Internetgateway to publicsubnet
    vpc_id =  aws_vpc.vpc.id
         route {
    cidr_block = "0.0.0.0/0"               
    gateway_id = aws_internet_gateway.IGW.id # #Traffic from Public Subnet reaches Internet via Internet Gateway
      }
    }

  resource "aws_route_table_association" "subnet1" {
  subnet_id      = aws_subnet.publicsubnets.id
  route_table_id = aws_route_table.PublicRT.id
   }

  resource "aws_route_table_association" "subnet2" {
  subnet_id      = aws_subnet.publicsubnetstwo.id
  route_table_id = aws_route_table.PublicRT.id
   }

 #Route table for Private Subnet's
 resource "aws_route_table" "PrivateRT" {    # Creating RT for Private Subnet
   vpc_id = aws_vpc.vpc.id
   route {
   cidr_block = "0.0.0.0/0"             # Traffic from Private Subnet reaches Internet via NAT Gateway
   nat_gateway_id = aws_nat_gateway.NAT.id
   }
    }

  resource "aws_route_table_association" "subnet3" {
  subnet_id      = aws_subnet.privatesubnets.id
  route_table_id = aws_route_table.PrivateRT.id
   }


 




