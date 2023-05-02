resource "aws_lb" "demo_elb" {
  name               = "cloud-lb-${var.ENVIRONMENT}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.web_sg.id]
  subnets            = [module.vpc.public_subnets[0], module.vpc.public_subnets[1]]
}

resource "aws_lb_target_group" "external-elb" {
  name     = "cloud-http-tg-${var.ENVIRONMENT}"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id
}

resource "aws_lb_target_group_attachment" "external-elb1" {
  target_group_arn = aws_lb_target_group.external-elb.arn
  target_id        = aws_instance.webserver[0].id
  port             = 80

  depends_on = [
    aws_instance.webserver[0],
  ]
}

resource "aws_lb_target_group_attachment" "external-elb2" {
  target_group_arn = aws_lb_target_group.external-elb.arn
  target_id        = aws_instance.webserver[1].id
  port             = 80

  depends_on = [
    aws_instance.webserver[1],
  ]
}

resource "aws_lb_listener" "external-elb" {
  load_balancer_arn = aws_lb.demo_elb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.external-elb.arn
  }
}