# Data sources for existing task definitions
data "aws_ecs_task_definition" "frontend_td" {
  task_definition = aws_ecs_task_definition.frontend_td.family
}

data "aws_ecs_task_definition" "yolo_td" {
  task_definition = aws_ecs_task_definition.yolo_td.family
}

data "aws_ecs_task_definition" "depth_td" {
  task_definition = aws_ecs_task_definition.depth_td.family
}

# Frontend Task Definition (React App)
resource "aws_ecs_task_definition" "frontend_td" {
  family                   = "mlops-frontend"
  network_mode             = "bridge"
  requires_compatibilities = ["EC2"]
  cpu                      = "512"
  memory                   = "1024"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }

  container_definitions = jsonencode([
    {
      name      = "frontend"
      image     = "058264233676.dkr.ecr.us-east-1.amazonaws.com/mlops/frontend:prod"
      essential = true
      cpu       = 0
      
      portMappings = [
        {
          name          = "frontend-3000-tcp"
          containerPort = 3000
          hostPort      = 0
          protocol      = "tcp"
          appProtocol   = "http"
        }
      ]
      
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.mlops_frontend_logs.name
          "mode"                  = "non-blocking"
          "awslogs-create-group"  = "true"
          "max-buffer-size"       = "25m"
          "awslogs-region"        = var.region
          "awslogs-stream-prefix" = "ecs"
        }
        secretOptions = []
      }

      healthCheck = {
        command     = ["CMD-SHELL", "curl -f http://localhost:3000/ || exit 1"]
        interval    = 30
        timeout     = 10
        retries     = 5
        startPeriod = 180
      }
      
      environment      = []
      environmentFiles = []
      mountPoints      = []
      volumesFrom      = []
      ulimits          = []
      systemControls   = []
    }
  ])

  tags = {
    Name = "mlops-frontend-td"
  }
}

# YOLO Backend Task Definition
resource "aws_ecs_task_definition" "yolo_td" {
  family                   = "mlops-yolo-backend"
  network_mode             = "bridge"
  requires_compatibilities = ["EC2"]
  cpu                      = "1024"
  memory                   = "2048"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }

  container_definitions = jsonencode([
    {
      name      = "yolo-backend"
      image     = "058264233676.dkr.ecr.us-east-1.amazonaws.com/mlops/yolo-backend:prod"
      essential = true
      cpu       = 0
      
      portMappings = [
        {
          name          = "yolo-backend-5000-tcp"
          containerPort = 5000
          hostPort      = 0
          protocol      = "tcp"
          appProtocol   = "http"
        }
      ]
      
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.mlops_yolo_logs.name
          "mode"                  = "non-blocking"
          "awslogs-create-group"  = "true"
          "max-buffer-size"       = "25m"
          "awslogs-region"        = var.region
          "awslogs-stream-prefix" = "ecs"
        }
        secretOptions = []
      }

      healthCheck = {
        command     = ["CMD-SHELL", "curl -f http://localhost:5000/health || exit 1"]
        interval    = 30
        timeout     = 10
        retries     = 5
        startPeriod = 180
      }
      
      environment = [
        {
          name  = "FLASK_ENV"
          value = "production"
        },
        {
          name  = "MODEL_PATH"
          value = "/app/models/yolov5s.pt"
        }
      ]
      environmentFiles = []
      mountPoints      = []
      volumesFrom      = []
      ulimits          = []
      systemControls   = []
    }
  ])

  tags = {
    Name = "mlops-yolo-backend-td"
  }
}

# Depth Estimation Backend Task Definition
resource "aws_ecs_task_definition" "depth_td" {
  family                   = "mlops-depth-backend"
  network_mode             = "bridge"
  requires_compatibilities = ["EC2"]
  cpu                      = "1024"
  memory                   = "3072"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }

  container_definitions = jsonencode([
    {
      name      = "depth-backend"
      image     = "058264233676.dkr.ecr.us-east-1.amazonaws.com/mlops/depth-backend:prod"
      essential = true
      cpu       = 0
      
      portMappings = [
        {
          name          = "depth-backend-5050-tcp"
          containerPort = 5050
          hostPort      = 0
          protocol      = "tcp"
          appProtocol   = "http"
        }
      ]
      
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.mlops_depth_logs.name
          "mode"                  = "non-blocking"
          "awslogs-create-group"  = "true"
          "max-buffer-size"       = "25m"
          "awslogs-region"        = var.region
          "awslogs-stream-prefix" = "ecs"
        }
        secretOptions = []
      }

      healthCheck = {
        command     = ["CMD-SHELL", "curl -f http://localhost:5050/health || exit 1"]
        interval    = 30
        timeout     = 10
        retries     = 5
        startPeriod = 180
      }
      
      environment = [
        {
          name  = "FLASK_ENV"
          value = "production"
        },
        {
          name  = "MODEL_PATH"
          value = "/app/models/depth_anything_vitl14.pth"
        }
      ]
      environmentFiles = []
      mountPoints      = []
      volumesFrom      = []
      ulimits          = []
      systemControls   = []
    }
  ])

  tags = {
    Name = "mlops-depth-backend-td"
  }
}