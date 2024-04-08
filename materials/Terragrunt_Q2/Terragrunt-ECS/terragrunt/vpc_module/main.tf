module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 2.0"

  name           = "sulav-vpc"
  cidr           = "10.10.0.0/16"
  azs            = ["us-east-1a", "us-east-1b"]
  public_subnets = ["10.10.1.0/24", "10.10.160.0/24"]

  enable_nat_gateway = false

  tags = {
    Name = "sulav-vpc"
  }
}

resource "aws_security_group" "api" {
  name        = "api"
  description = "Allow inbound traffic"
  vpc_id      = module.vpc.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role" "execution_role" {
  name = "sulav-ecsTaskExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })
  tags = {
    Name = "sulav-ecsTaskExecutionRole"
  }
}


module "ecs" {
  source  = "terraform-aws-modules/ecs/aws"
  version = "~> 2.0"

  name = "sulav-api"
  tags = {
    Name = "sulav-api"
  }
}

resource "aws_ecs_task_definition" "api" {
  family                   = "api"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.execution_role.arn

  container_definitions = jsonencode([{
    name  = "api"
    image = "sulavadk7/backend-image"
    portMappings = [{
      containerPort = 3000
      hostPort      = 3000
      protocol      = "tcp"
    }]
  }])
}

resource "aws_ecs_service" "api" {
  name    = "api"
  cluster = module.ecs.this_ecs_cluster_arn

  task_definition = aws_ecs_task_definition.api.arn
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = module.vpc.public_subnets
    security_groups  = [aws_security_group.api.id]
    assign_public_ip = true
  }
  desired_count = 1
}


