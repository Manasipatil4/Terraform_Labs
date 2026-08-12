# Implemented launch template, asg, cloudwatch alarm, alb, alb listener and alb listener rule for home and cloth pages

provider "aws" {
    region = "eu-north-1" 
}

resource "aws_launch_template" "home-temp"{
    name = "home-temp"
    image_id = "ami-0aba19e56f3eaec05"
    instance_type = "t3.micro"
    key_name = "manasi"
    vpc_security_group_ids = ["sg-0ee539fda995a1ed7"]
    user_data = base64encode(<<-EOF
        #!/bin/bash
        apt update -y
        apt install nginx -y
        echo "home page" > /var/www/html/index.html
        systemctl start nginx
        systemctl enable nginx
    EOF
    )
    tags = {
        Name = "home-temp"
    }
}

resource "aws_launch_template" "cloth-temp"{
    name = "cloth-temp"
    image_id = "ami-0aba19e56f3eaec05"
    instance_type = "t3.micro"
    key_name = "manasi"
    vpc_security_group_ids = ["sg-0ee539fda995a1ed7"]
    user_data = base64encode(<<-EOF
        #!/bin/bash
        apt update -y
        apt install nginx -y
        mkdir -p /var/www/html/cloth
        echo "sale sale sale" > /var/www/html/cloth/index.html
        systemctl start nginx
        systemctl enable nginx
    EOF
    )
    tags = {
        Name = "cloth-temp"
    }
}

resource "aws_autoscaling_group" "home-asg" {
    name = "home-asg"
    availability_zones = ["eu-north-1a", "eu-north-1b", "eu-north-1c"]
    max_size = 1
    min_size = 1
    desired_capacity = 1
    health_check_type = "EC2"
    termination_policies = ["OldestInstance"]
    launch_template {
        id = aws_launch_template.home-temp.id
        version = "$Latest"
    }
}


resource "aws_autoscaling_group" "cloth-asg" {
    name = "cloth-asg"
    availability_zones = ["eu-north-1a", "eu-north-1b", "eu-north-1c"]
    max_size = 1
    min_size = 1
    desired_capacity = 1
    health_check_type = "EC2"
    termination_policies = ["OldestInstance"]
    launch_template {
        id = aws_launch_template.cloth-temp.id
        version = "$Latest"
    }
}


resource "aws_autoscaling_policy" "home-scale-up" {
    name = "home-scale-up"
    scaling_adjustment = 1
    adjustment_type = "ChangeInCapacity"
    cooldown = 300
    autoscaling_group_name = aws_autoscaling_group.home-asg.name
}

resource "aws_autoscaling_policy" "cloth-scale-up" {
    name = "cloth-scale-up"
    scaling_adjustment = 1
    adjustment_type = "ChangeInCapacity"
    cooldown = 300
    autoscaling_group_name = aws_autoscaling_group.cloth-asg.name
}



resource "aws_cloudwatch_metric_alarm" "home-alarm" {
    alarm_description = "Alarm for home"
    alarm_actions = [aws_autoscaling_policy.home-scale-up.arn]
    alarm_name = "home-alarm"
    comparison_operator = "LessThanOrEqualToThreshold"
    namespace = "AWS/EC2"
    metric_name = "CPUUtilization"  
    threshold = "25"
    evaluation_periods = "5"
    period = "30"
    statistic = "Average"

    dimensions = {
        AutoScalingGroupName = aws_autoscaling_group.home-asg.name
    }
}



resource "aws_cloudwatch_metric_alarm" "cloth-alarm" {
    alarm_description = "Alarm for cloth"
    alarm_actions = [aws_autoscaling_policy.cloth-scale-up.arn]
    alarm_name = "cloth-alarm"
    comparison_operator = "LessThanOrEqualToThreshold"
    namespace = "AWS/EC2"
    metric_name = "CPUUtilization"  
    threshold = "25"
    evaluation_periods = "5"
    period = "30"
    statistic = "Average"

    dimensions = {
        AutoScalingGroupName = aws_autoscaling_group.cloth-asg.name
    }
}

resource "aws_lb_target_group" "home-tg" {
    name = "home-tg"
    port = 80
    protocol = "HTTP"
    vpc_id = "vpc-0d31efcc31c093aba"  
}



resource "aws_lb_target_group" "cloth-tg" {
    name = "cloth-tg"
    port = 80
    protocol = "HTTP"
    vpc_id = "vpc-0d31efcc31c093aba"  
}


resource "aws_autoscaling_attachment" "home-asg-attach" {
    autoscaling_group_name = aws_autoscaling_group.home-asg.id
    lb_target_group_arn = aws_lb_target_group.home-tg.arn
}

resource "aws_autoscaling_attachment" "cloth-asg-attach" {
    autoscaling_group_name = aws_autoscaling_group.cloth-asg.id
    lb_target_group_arn = aws_lb_target_group.cloth-tg.arn
}


resource "aws_lb" "alb" {
    name = "alb"
    internal = false
    load_balancer_type = "application"
    security_groups = ["sg-0ee539fda995a1ed7"]
    subnets = ["subnet-0502db0f7223c1588", "subnet-056d72827e8145152", "subnet-0a38ca3e43b18efb9"]
    tags = {
        Environment = "prod"
    }
}

resource "aws_lb_listener" "my_home_alb_listener" {
    load_balancer_arn = aws_lb.alb.arn
    port = 80
    protocol = "HTTP"

    default_action {
        type = "forward"
        target_group_arn = aws_lb_target_group.home-tg.arn
    }
}

resource "aws_lb_listener_rule" "hom-rule" {
    listener_arn = aws_lb_listener.my_home_alb_listener.arn
    priority = 10

    action {
        type = "forward"
        target_group_arn = aws_lb_target_group.cloth-tg.arn
    }

    condition {
        path_pattern {
            values = ["/cloth/*"]
        }
    }
}






