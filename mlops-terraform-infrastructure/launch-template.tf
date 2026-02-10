# Get the latest ECS-optimized AMI
data "aws_ami" "ecs_optimized" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-*-x86_64-ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Extract public key from existing .pem file
locals {
  public_key = trimspace(file("key-srishti-rai-2025.pub"))
}

# Key pair for EC2 instances (create new one for Terraform)
resource "aws_key_pair" "ecs_key_pair" {
  key_name   = var.ecs_key_pair_name
  public_key = local.public_key
}

# Launch template for ECS instances (replaces launch configuration)
resource "aws_launch_template" "ecs_launch_template" {
  name                   = "ecs-launch-mlops-template"
  image_id               = data.aws_ami.ecs_optimized.id
  instance_type          = "t3.large"
  key_name               = aws_key_pair.ecs_key_pair.key_name
  vpc_security_group_ids = [aws_security_group.test_public_sg.id]

  iam_instance_profile {
    name = aws_iam_instance_profile.ecs_instance_profile.name
  }

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size           = 30
      volume_type           = "gp3"
      delete_on_termination = true
    }
  }

  user_data = base64encode(<<-EOF
    #!/bin/bash
    echo ECS_CLUSTER=${var.ecs_cluster} >> /etc/ecs/ecs.config
    echo ECS_ENABLE_TASK_IAM_ROLE=true >> /etc/ecs/ecs.config
    echo ECS_ENABLE_TASK_IAM_ROLE_NETWORK_HOST=true >> /etc/ecs/ecs.config
    
    # Install CloudWatch agent
    yum update -y
    yum install -y amazon-cloudwatch-agent
    
    # Start ECS agent
    start ecs
  EOF
  )

  lifecycle {
    create_before_destroy = true
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "mlops-ecs-instance"
    }
  }
}