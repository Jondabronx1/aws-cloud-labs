variable "aws_region" {
  description = "Aws region to deploy infrastructure"
  type        = string

}
variable "public_subnets" {
  description = "CIDR block for public subnets"
  type        = map(string)
}

variable "private_subnets" {
  description = "CIDR block for public subnets"
  type        = map(string)
}

variable "db_subnets" {
  description = "subnet which ocntains my database"
  type        = map(string)

}

variable "my_ip" {
  description = "Your public ip for ssh access"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR blocks for my vpc"
  type        = string

}

variable "instance_type" {

  description = "type of instance that is used"
  type        = string
  default     = "t2.micro"
}

variable "db_username" {
  description = "username"
  type        = string

}

variable "db_password" {
  description = "password"
  type        = string
  sensitive   = true

}
