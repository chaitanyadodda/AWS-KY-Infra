variable "cidr-value" {
  type = string 
  default = "10.0.0.0/16"
}

variable "bastion-cidr-value" {
  type = string 
  default = "10.0.13.0/16"
}

variable "publicsubnet" {
  type = string 
  default = "10.0.0.0/20"
}
variable "publicsubnettwo" {
  type = string 
  default = "10.0.16.0/20"
}

variable "privatesubnet" {
  type = string 
  default = "10.0.144.0/20"
}

variable "privatesubnettwo" {
  type = string 
  default = "10.0.128.0/20"
}

variable "ec2-ami" {
    type = string
    default = "ami-0a8a24772b8f01294"
}

variable "alb_name" {
    type = string
    default = "Jenkins-alb"
}
