output "alb_dns_name" {
  description = "Application Load Balencer DNS"
  value       = aws_lb.app_lb.dns

}

output "rds_endpoint" {
  description = "Database Endpoint"
  value       = aws_db_instance.my_db.endpoint
}

output "ec2_private_ipd" {
  description = "Private ips for EC2"
  value = [for instance in aws_instance.aws_instance.my_app :
    instance.private_ip
  ]
}
