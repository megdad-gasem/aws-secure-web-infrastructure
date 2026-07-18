resource "aws_iam_role" "ec2_monitoring_role" {
  name = "EC2-CloudWatch-Agent-Megdad"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# ربط سياسة CloudWatch Agent بالـ Role
resource "aws_iam_role_policy_attachment" "cw_agent_server" {
  role       = aws_iam_role.ec2_monitoring_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

# ربط سياسة الـ SSM بالـ Role للاتصال الآمن
resource "aws_iam_role_policy_attachment" "ssm_managed" {
  role       = aws_iam_role.ec2_monitoring_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# تجهيز الـ Profile اللي حيركب في السيرفر حقيقةً
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "EC2-CloudWatch-Instance-Profile"
  role = aws_iam_role.ec2_monitoring_role.name
}