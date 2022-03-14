output "vpcid" {
    value = aws_vpc.vpc.id
    }

output "elasticIp" {
   value = aws_eip.NAT.public_ip
}