# CloudWatch Log Groups
resource "aws_cloudwatch_log_group" "mlops_frontend_logs" {
  name              = "/ecs/mlops-frontend"
  retention_in_days = 7

  tags = {
    Name = "mlops-frontend-logs"
  }
}

resource "aws_cloudwatch_log_group" "mlops_yolo_logs" {
  name              = "/ecs/mlops-yolo-backend"
  retention_in_days = 7

  tags = {
    Name = "mlops-yolo-backend-logs"
  }
}

resource "aws_cloudwatch_log_group" "mlops_depth_logs" {
  name              = "/ecs/mlops-depth-backend"
  retention_in_days = 7

  tags = {
    Name = "mlops-depth-backend-logs"
  }
}

# CloudWatch Alarms for Monitoring
resource "aws_cloudwatch_metric_alarm" "high_cpu_frontend" {
  alarm_name          = "mlops-frontend-high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "300"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "This metric monitors frontend CPU utilization"
  alarm_actions       = []

  dimensions = {
    ServiceName = aws_ecs_service.frontend_ecs_service.name
    ClusterName = aws_ecs_cluster.mlops_ecs_cluster.name
  }

  tags = {
    Name = "mlops-frontend-high-cpu-alarm"
  }
}

resource "aws_cloudwatch_metric_alarm" "high_cpu_yolo" {
  alarm_name          = "mlops-yolo-high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "300"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "This metric monitors YOLO backend CPU utilization"
  alarm_actions       = []

  dimensions = {
    ServiceName = aws_ecs_service.yolo_ecs_service.name
    ClusterName = aws_ecs_cluster.mlops_ecs_cluster.name
  }

  tags = {
    Name = "mlops-yolo-high-cpu-alarm"
  }
}

resource "aws_cloudwatch_metric_alarm" "high_cpu_depth" {
  alarm_name          = "mlops-depth-high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "300"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "This metric monitors Depth backend CPU utilization"
  alarm_actions       = []

  dimensions = {
    ServiceName = aws_ecs_service.depth_ecs_service.name
    ClusterName = aws_ecs_cluster.mlops_ecs_cluster.name
  }

  tags = {
    Name = "mlops-depth-high-cpu-alarm"
  }
}