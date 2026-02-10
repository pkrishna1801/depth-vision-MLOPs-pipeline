# ECS Cluster
resource "aws_ecs_cluster" "mlops_ecs_cluster" {
  name = var.ecs_cluster

  setting {
    name  = "containerInsights"
    value = "enabled"  # Enable CloudWatch Container Insights
  }

  tags = {
    Name = var.ecs_cluster
  }
}

# ECS Capacity Provider
resource "aws_ecs_capacity_provider" "mlops_capacity_provider" {
  name = "${var.ecs_cluster}-capacity-provider"

  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.ecs_autoscaling_group.arn
    managed_termination_protection = "ENABLED"

    managed_scaling {
      maximum_scaling_step_size = 2
      minimum_scaling_step_size = 1
      status                    = "ENABLED"
      target_capacity           = var.target_capacity
    }
  }

  tags = {
    Name = "${var.ecs_cluster}-capacity-provider"
  }
}

# Attach capacity provider to cluster
resource "aws_ecs_cluster_capacity_providers" "mlops_cluster_cp" {
  cluster_name = aws_ecs_cluster.mlops_ecs_cluster.name

  capacity_providers = [aws_ecs_capacity_provider.mlops_capacity_provider.name]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = aws_ecs_capacity_provider.mlops_capacity_provider.name
  }
}