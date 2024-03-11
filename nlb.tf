# Data Source to fetch RDS instance details
data "aws_db_instance" "rds_instances" {
  db_instance_identifier = "my-rds-instance"  # Replace with your RDS instance identifier
}


resource "aws_security_group" "nlb_sg" {
  vpc_id = "vpc-09884629ffbebbeb7" # Replace with your VPC ID

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create NLB
resource "aws_lb" "nlb" {
  name               = "my-nlb"
  internal           = true
  load_balancer_type = "network"
  subnets            = [aws_subnet.private_subnet1.id, aws_subnet.private_subnet2.id] # Replace with your subnet IDs
  security_groups    = [aws_security_group.nlb_sg.id]

  enable_deletion_protection = false
}

# Create Target Group for RDS
resource "aws_lb_target_group" "rds_target_group" {
  name     = "rds-target-group"
  port     = 3306
  protocol = "TCP"
  vpc_id   = "vpc-09884629ffbebbeb7" # Replace with your VPC ID

  health_check {
    enabled             = true
    port                = "3306"
    protocol            = "TCP"
    #matcher             = "200-399"
    interval            = 30
    timeout             = 10
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}

# Attach RDS instance to the Target Group
#resource "aws_lb_target_group_attachment" "rds_attachment" {
 # target_group_arn = "arn:aws:elasticloadbalancing:us-east-1:851725255676:targetgroup/rds-target-group/d7bceed2d0bcc176"
  #target_id        = data.aws_db_instance.rds_instances.id # Replace with your RDS instance identifier
  #port             = 3306
#}