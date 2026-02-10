# Auto Scaling Group for ECS cluster
resource "aws_autoscaling_group" "ecs_autoscaling_group" {
  name                = "mlops-ecs-asg-tf"
  max_size            = var.max_instance_size
  min_size            = var.min_instance_size
  desired_capacity    = var.desired_capacity
  vpc_zone_identifier = [aws_subnet.test_public_sn_01.id, aws_subnet.test_public_sn_02.id]
  
  # Use launch template instead of launch configuration
  launch_template {
    id      = aws_launch_template.ecs_launch_template.id
    version = "$Latest"
  }
  health_check_type    = "ELB"
  health_check_grace_period = 300

  # Enable instance protection from scale-in (managed by capacity provider)
  protect_from_scale_in = true

  tag {
    key                 = "Name"
    value               = "mlops-ecs-instance"
    propagate_at_launch = true
  }

  tag {
    key                 = "AmazonECSManaged"
    value               = ""
    propagate_at_launch = false
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Application Auto Scaling Target for ECS Services
resource "aws_appautoscaling_target" "ecs_target_frontend" {
  max_capacity       = 10
  min_capacity       = 1
  resource_id        = "service/${aws_ecs_cluster.mlops_ecs_cluster.name}/${aws_ecs_service.frontend_ecs_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"

  depends_on = [aws_ecs_service.frontend_ecs_service]
}

resource "aws_appautoscaling_target" "ecs_target_yolo" {
  max_capacity       = 10
  min_capacity       = 1
  resource_id        = "service/${aws_ecs_cluster.mlops_ecs_cluster.name}/${aws_ecs_service.yolo_ecs_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"

  depends_on = [aws_ecs_service.yolo_ecs_service]
}

resource "aws_appautoscaling_target" "ecs_target_depth" {
  max_capacity       = 10
  min_capacity       = 1
  resource_id        = "service/${aws_ecs_cluster.mlops_ecs_cluster.name}/${aws_ecs_service.depth_ecs_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"

  depends_on = [aws_ecs_service.depth_ecs_service]
}

# Auto Scaling Policy - Scale Up (CPU)
resource "aws_appautoscaling_policy" "ecs_policy_up_frontend" {
  name               = "mlops-scale-up-frontend"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target_frontend.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target_frontend.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target_frontend.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    target_value = 70.0
    scale_in_cooldown  = 300
    scale_out_cooldown = 300
  }
}

resource "aws_appautoscaling_policy" "ecs_policy_up_yolo" {
  name               = "mlops-scale-up-yolo"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target_yolo.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target_yolo.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target_yolo.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    target_value = 70.0
    scale_in_cooldown  = 300
    scale_out_cooldown = 300
  }
}

resource "aws_appautoscaling_policy" "ecs_policy_up_depth" {
  name               = "mlops-scale-up-depth"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target_depth.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target_depth.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target_depth.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    target_value = 70.0
    scale_in_cooldown  = 300
    scale_out_cooldown = 300
  }
}