output "alb_dns_name" {
  description = "The public URL to access your secure web server"
  value       = "http://${aws_lb.external.dns_name}"
}