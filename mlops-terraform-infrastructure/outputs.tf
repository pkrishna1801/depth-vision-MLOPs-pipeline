output "region" {
  description = "AWS region"
  value       = var.region
}

output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.test_vpc.id
}

output "public_subnet_01_id" {
  description = "ID of the first public subnet"
  value       = aws_subnet.test_public_sn_01.id
}

output "public_subnet_02_id" {
  description = "ID of the second public subnet"
  value       = aws_subnet.test_public_sn_02.id
}

output "security_group_id" {
  description = "ID of the security group"
  value       = aws_security_group.test_public_sg.id
}

output "ecs_cluster_name" {
  description = "Name of the ECS cluster"
  value       = aws_ecs_cluster.mlops_ecs_cluster.name
}

output "ecs_cluster_arn" {
  description = "ARN of the ECS cluster"
  value       = aws_ecs_cluster.mlops_ecs_cluster.arn
}

output "load_balancer_dns_name" {
  description = "The DNS name of the load balancer"
  value       = aws_alb.ecs_load_balancer.dns_name
}

output "load_balancer_zone_id" {
  description = "The zone ID of the load balancer"
  value       = aws_alb.ecs_load_balancer.zone_id
}

output "frontend_service_name" {
  description = "Name of the frontend ECS service"
  value       = aws_ecs_service.frontend_ecs_service.name
}

output "yolo_service_name" {
  description = "Name of the YOLO ECS service"
  value       = aws_ecs_service.yolo_ecs_service.name
}

output "depth_service_name" {
  description = "Name of the Depth ECS service"
  value       = aws_ecs_service.depth_ecs_service.name
}

output "capacity_provider_name" {
  description = "Name of the ECS capacity provider"
  value       = aws_ecs_capacity_provider.mlops_capacity_provider.name
}

output "autoscaling_group_name" {
  description = "Name of the autoscaling group"
  value       = aws_autoscaling_group.ecs_autoscaling_group.name
}

output "frontend_target_group_arn" {
  description = "ARN of the frontend target group"
  value       = aws_alb_target_group.frontend_target_group.arn
}

output "yolo_target_group_arn" {
  description = "ARN of the YOLO target group"
  value       = aws_alb_target_group.yolo_target_group.arn
}

output "depth_target_group_arn" {
  description = "ARN of the Depth target group"
  value       = aws_alb_target_group.depth_target_group.arn
}

# Provide application URLs
output "application_url" {
  description = "URL to access the MLOps frontend application"
  value       = "http://${aws_alb.ecs_load_balancer.dns_name}:3000"
}

output "yolo_api_url" {
  description = "URL to access the YOLO API"
  value       = "http://${aws_alb.ecs_load_balancer.dns_name}:5000"
}

output "depth_api_url" {
  description = "URL to access the Depth API"
  value       = "http://${aws_alb.ecs_load_balancer.dns_name}:5050"
}