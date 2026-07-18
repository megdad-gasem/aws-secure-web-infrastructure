#!/bin/bash
# تحديث الحزم وتنزيل الـ Nginx
apt-get update -y
apt-get install -y nginx

# تشغيل وتفعيل الـ Nginx ليشتغل مع بداية السيرفر
systemctl start nginx
systemctl enable nginx

# عمل صفحة ويب ترحيبية مخصصة
echo "<h1>Welcome to Secure Web Server - Successfully Deployed via Terraform</h1>" > /var/www/html/index.html

# تنزيل وتثبيت الـ CloudWatch Agent الرسمي
wget https://s3.amazonaws.com/amazoncloudwatch-agent/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb
dpkg -i -E ./amazon-cloudwatch-agent.deb

# إنشاء ملف إعدادات الـ CloudWatch Agent وتحديد اللوقات والمتركس
cat << 'EOF' > /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json
{
  "agent": {
    "metrics_collection_interval": 60,
    "run_as_user": "cwagent"
  },
  "metrics": {
    "append_dimensions": {
      "InstanceId": "${aws:InstanceId}"
    },
    "metrics_collected": {
      "mem": {
        "measurement": [
          "mem_used_percent"
        ],
        "metrics_collection_interval": 60
      }
    }
  },
  "logs": {
    "logs_collected": {
      "files": {
        "collect_list": [
          {
            "file_path": "/var/log/nginx/access.log",
            "log_group_name": "access.log",
            "log_stream_name": "{instance_id}",
            "retention_in_days": 30
          }
        ]
      }
    }
  }
}
EOF

# تشغيل الـ CloudWatch Agent بالإعدادات المكتوبة فوق طوالي
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json