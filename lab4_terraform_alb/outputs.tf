output "alb_dns_name" {
  description = "DNS name of the application load balancer"
  value       = aws_lb.app_lb.dns_name

}

output "db_endpoint" {
  description = "RDS endpoint"
  value       = aws_db_instance.my_db.endpoint
  sensitive   = true

}

# creates a list of private IP addresses from all ec2 instanes
output "app_private_ips" {
  description = "Private IPs of application instances"
  value       = [for instance in aws_instance.my_app : instance.private_ip]

}
