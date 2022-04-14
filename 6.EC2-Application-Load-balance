#creating applicationn load balancer
resource "aws_lb" "alb" {  
  name            = "${var.alb_name}"  
  subnets         = [aws_subnet.publicsubnets.id, aws_subnet.publicsubnetstwo.id]
  security_groups = [aws_security_group.ec2-security-grp.id]
  load_balancer_type = "application"
  internal           = false
  
 }

#creating alb targetgroup - attaching to Ec2 - instance target group

resource "aws_lb_target_group" "alb-jenkins-tg" {
  name     = "alb-jenkins-tg"
  port     = 8080   #attaching to jenkins port 8080
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id    #attching to VPC
}

#attaching jenkins instance to alb target group

resource "aws_lb_target_group_attachment" "jenkins-target" {
  target_group_arn = aws_lb_target_group.alb-jenkins-tg.arn
  target_id        = aws_instance.Jenkins-EC2.id  #attaching to jenkins Ec2, multiple instances by comma seperated
  port             = 8080    #jenkins port
}

 #creating alb listner  
 resource "aws_lb_listener" "ec2-jenkins-listner" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"   #443 if SSL required
  protocol          = "HTTP"   # HTTPS if port 443
 # ssl_policy        = "ELBSecurityPolicy-2016-08"
  #certificate_arn   = "arn:aws:acm:us-west-1:043000801262:certificate/f191976f-41d0-44f5-be02-7dc3a4ddf99d"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb-jenkins-tg.arn
  }
  depends_on = [
    aws_lb_target_group.alb-jenkins-tg
  ]
}



