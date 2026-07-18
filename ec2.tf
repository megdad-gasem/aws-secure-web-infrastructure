data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # الشركة الرسمية لـ Ubuntu (Canonical)
}

resource "aws_instance" "web_server" {
  ami                  = data.aws_ami.ubuntu.id
  instance_type        = var.instance_type
  subnet_id            = aws_subnet.private_az1.id
  vpc_security_group_ids = [aws_security_group.ec2.id]
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  # ربط السيرفر بسكربت الـ التثبيت التلقائي الفوق
  user_data = file("${path.module}/userdata/install.sh")

  tags = {
    Name = "Nginx-Streaming-Server"
  }
}