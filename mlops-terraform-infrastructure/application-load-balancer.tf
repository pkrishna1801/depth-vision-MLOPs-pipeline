# Application Load Balancer
resource "aws_alb" "ecs_load_balancer" {
  name               = "mlops-ecs-alb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.test_public_sg.id]
  subnets            = [aws_subnet.test_public_sn_01.id, aws_subnet.test_public_sn_02.id]

  enable_deletion_protection = false

  tags = {
    Name = "mlops-ecs-alb-tf"
  }
}

# Target Group for Frontend (React App) - Port 3000
resource "aws_alb_target_group" "frontend_target_group" {
  name     = "mlops-frontend-tf-tg"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = aws_vpc.test_vpc.id

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 30
    matcher             = "200"
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
  }

  tags = {
    Name = "mlops-frontend-tf-tg"
  }
}

# Target Group for YOLO API - Port 5000
resource "aws_alb_target_group" "yolo_target_group" {
  name     = "mlops-yolo-tf-tg"
  port     = 5000
  protocol = "HTTP"
  vpc_id   = aws_vpc.test_vpc.id

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 30
    matcher             = "200"
    path                = "/health"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
  }

  tags = {
    Name = "mlops-yolo-tf-tg"
  }
}

# Target Group for Depth API - Port 5050
resource "aws_alb_target_group" "depth_target_group" {
  name     = "mlops-depth-tf-tg"
  port     = 5050
  protocol = "HTTP"
  vpc_id   = aws_vpc.test_vpc.id

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 30
    matcher             = "200"
    path                = "/health"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
  }

  tags = {
    Name = "mlops-depth-tf-tg"
  }
}

# ALB Listener for Frontend - Port 3000
resource "aws_alb_listener" "frontend_listener" {
  load_balancer_arn = aws_alb.ecs_load_balancer.arn
  port              = "3000"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.frontend_target_group.arn
  }
}

# ALB Listener for YOLO API - Port 5000
resource "aws_alb_listener" "yolo_listener" {
  load_balancer_arn = aws_alb.ecs_load_balancer.arn
  port              = "5000"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.yolo_target_group.arn
  }
}

# ALB Listener for Depth API - Port 5050
resource "aws_alb_listener" "depth_listener" {
  load_balancer_arn = aws_alb.ecs_load_balancer.arn
  port              = "5050"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.depth_target_group.arn
  }
}