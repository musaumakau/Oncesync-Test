resource "aws_codedeploy_app" "nodejs_app" {
  name             = "nodejs_app"
  compute_platform = "Server"
}

resource "aws_codedeploy_deployment_config" "demo_config" {
  deployment_config_name = "CodeDeployDefault2.EC2AllAtOnce"


  minimum_healthy_hosts {
    type  = "HOST_COUNT"
    value = 0
  }
}

resource "aws_codedeploy_deployment_group" "cd_dg1" {
  app_name              = aws_codedeploy_app.nodejs_app.name
  deployment_group_name = "cd_dg1"



  auto_rollback_configuration {
    enabled = false
    events  = ["DEPLOYMENT_FAILURE"]
  }

  load_balancer_info {
    target_group_info {
      name = aws_lb_target_group.external_alb_tg_app1.name
    }
  }

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "IN_PLACE"
  }

  autoscaling_groups = [aws_autoscaling_group.devops_web_asg.id]
}