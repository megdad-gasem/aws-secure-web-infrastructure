# 1. إنشاء نظام التنبيهات (SNS Topic)
resource "aws_sns_topic" "alerts" {
  name = "server-security-alerts"
}

# 2. ربط إيميلك بنظام التنبيهات عشان تجيك الرسائل عليه
resource "aws_sns_topic_subscription" "email_sub" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = var.admin_email
}

# 3. إنذار في حال استهلاك الذاكرة (RAM) زاد عن 80%
resource "aws_cloudwatch_metric_alarm" "high_memory" {
  alarm_name          = "high-memory-usage-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "mem_used_percent"
  namespace           = "CWAgent"
  period              = "60"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "This metric monitors EC2 memory utilization from CloudWatch Agent"
  alarm_actions       = [aws_sns_topic.alerts.arn]
}

# 4. إنذار في حال الـ Load Balancer رجع أخطاء من السيرفر (HTTP 5XX)
resource "aws_cloudwatch_metric_alarm" "alb_5xx_errors" {
  alarm_name          = "alb-high-5xx-errors"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "HTTPCode_Target_5XX_Count"
  namespace           = "AWS/ApplicationELB"
  period              = "60"
  statistic           = "Sum"
  threshold           = "5"
  alarm_description   = "Triggers if the server returns more than 5 internal server errors in a minute"
  alarm_actions       = [aws_sns_topic.alerts.arn]

  dimensions = {
    LoadBalancer = aws_lb.external.arn_suffix
  }
}