# Frontend ECS Service
resource "aws_ecs_service" "frontend_ecs_service" {
  name            = "mlops-frontend-service"
  cluster         = aws_ecs_cluster.mlops_ecs_cluster.id
  task_definition = "${aws_ecs_task_definition.frontend_td.family}:${max(aws_ecs_task_definition.frontend_td.revision, data.aws_ecs_task_definition.frontend_td.revision)}"
  desired_count   = 1
  
  # Use capacity provider strategy instead of launch_type
  capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.mlops_capacity_provider.name
    weight            = 100
    base              = 1
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.frontend_target_group.arn
    container_name   = "frontend"
    container_port   = 3000
  }

  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 50

  # Ensure ALB is created first
  depends_on = [
    aws_alb_listener.frontend_listener,
    aws_iam_role_policy_attachment.ecs_service_role_attachment,
  ]

  tags = {
    Name = "mlops-frontend-service"
  }
}

# YOLO Backend ECS Service
resource "aws_ecs_service" "yolo_ecs_service" {
  name            = "mlops-yolo-service"
  cluster         = aws_ecs_cluster.mlops_ecs_cluster.id
  task_definition = "${aws_ecs_task_definition.yolo_td.family}:${max(aws_ecs_task_definition.yolo_td.revision, data.aws_ecs_task_definition.yolo_td.revision)}"
  desired_count   = 1

  # Use capacity provider strategy instead of launch_type
  capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.mlops_capacity_provider.name
    weight            = 100
    base              = 1
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.yolo_target_group.arn
    container_name   = "yolo-backend"
    container_port   = 5000
  }

  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 50

  # Ensure ALB is created first
  depends_on = [
    aws_alb_listener.yolo_listener,
    aws_iam_role_policy_attachment.ecs_service_role_attachment,
  ]

  tags = {
    Name = "mlops-yolo-service"
  }
}

# Depth Backend ECS Service
resource "aws_ecs_service" "depth_ecs_service" {
  name            = "mlops-depth-service"
  cluster         = aws_ecs_cluster.mlops_ecs_cluster.id
  task_definition = "${aws_ecs_task_definition.depth_td.family}:${max(aws_ecs_task_definition.depth_td.revision, data.aws_ecs_task_definition.depth_td.revision)}"
  desired_count   = 1

  # Use capacity provider strategy instead of launch_type
  capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.mlops_capacity_provider.name
    weight            = 100
    base              = 1
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.depth_target_group.arn
    container_name   = "depth-backend"
    container_port   = 5050
  }

  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 50

  # Ensure ALB is created first
  depends_on = [
    aws_alb_listener.depth_listener,
    aws_iam_role_policy_attachment.ecs_service_role_attachment,
  ]

  tags = {
    Name = "mlops-depth-service"
  }
}