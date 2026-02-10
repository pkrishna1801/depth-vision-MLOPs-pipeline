variable "ecs_cluster" {
  description = "ECS cluster name"
  default     = "mlops-ecs-cluster"
}

variable "ecs_key_pair_name" {
  description = "ECS key pair name"
  default     = "mlops-key-pair"
}

variable "region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "availability_zone" {
  description = "availability zone used, based on region"
  default     = "us-east-1a"
}

variable "aws_account_id" {
  description = "AWS Account ID for ECR repositories"
  type        = string
}

########################### VPC Config ################################
variable "test_vpc" {
  description = "VPC for Test environment"
  default     = "mlops-vpc"
}

variable "test_network_cidr" {
  description = "IP addressing for Test Network"
  default     = "10.0.0.0/16"
}

variable "test_public_01_cidr" {
  description = "Public 0.0 CIDR for externally accessible subnet"
  default     = "10.0.1.0/24"
}

variable "test_public_02_cidr" {
  description = "Public 0.0 CIDR for externally accessible subnet"
  default     = "10.0.2.0/24"
}

########################### Autoscale Config ################################
variable "max_instance_size" {
  description = "Maximum number of instances in the cluster"
  default     = 4
  type        = number
  validation {
    condition     = var.max_instance_size >= 1
    error_message = "Maximum instance size must be at least 1."
  }
}

variable "min_instance_size" {
  description = "Minimum number of instances in the cluster"
  default     = 2
  type        = number
  validation {
    condition     = var.min_instance_size >= 1 && var.min_instance_size <= var.max_instance_size
    error_message = "Minimum instance size must be at least 1 and less than or equal to the maximum instance size."
  }
}

variable "desired_capacity" {
  description = "Desired number of instances in the cluster"
  default     = 2
  type        = number
  validation {
    condition     = var.desired_capacity >= var.min_instance_size && var.desired_capacity <= var.max_instance_size
    error_message = "Desired capacity must be between the minimum and maximum instance sizes."
  }
}

variable "target_capacity" {
  description = "Target capacity percentage for capacity provider"
  default     = 90
  type        = number
  validation {
    condition     = var.target_capacity >= 1 && var.target_capacity <= 100
    error_message = "Target capacity must be between 1 and 100."
  }
}