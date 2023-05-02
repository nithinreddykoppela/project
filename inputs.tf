variable "AWS_REGION" {
  default = "ap-south-1"
}

variable "CIDR_BLOCK" {
  description = "The CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "ENVIRONMENT" {
  description = "Environment of the stack"
  default     = "demo"
}

########################
#### VPC Parameters ####
########################
variable "VPC_NAME" {
  description = "Name of the VPC"
  default = "cloud-vpc"
}

variable "INSTANCE_TENANCY" {
  description = "A tenancy option for instances launched into the VPC"
  default     = "default"
}

variable "ENABLE_DNS_HOSTNAMES" {
  description = "Should be true to enable DNS hostnames in the VPC"
  default     = true
}

variable "ENABLE_DNS_SUPPORT" {
  description = "Should be true to enable DNS support in the VPC"
  default     = true
}

variable "PUBLIC_SUBNET_NAME" {
  description = "Name of the public subnet"
  default     = "cloud-public-sb"
}

variable "PUBLIC_SUBNET_CIDR_BLOCK" {
  description = "The CIDR block for the Subnet"
  default     = "10.0.1.0/24"
}

variable "PRIVATE_SUBNET_CIDR_BLOCK" {
  description = "The CIDR block for the Subnet"
  default     = "10.0.2.0/24"
}

variable "INTERNET_GATEWAY_NAME" {
  description = "Name of the internet gateway"
  default     = "cloud-web-ig"
}

variable "ROUTE_TABLE_NAME" {
  description = "Name of the Route table"
  default     = "cloud-web-rt"
}

variable "PRIVATE_SUBNET_NAME" {
  type    = string
  default = "cloud-private-sb"
}

variable "NAT_GATEWAY_NAME" {
  description = "Name of the Nat gateway"
  default     = "cloud-gateway"
}


########################
#### EC2 Parameters ####
########################
variable "SERVER_AMI" {
    default = "ami-02eb7a4783e7e9317"
}

variable "SERVER_PROFILE" {
    default = "t2.micro"
}

variable "SSH_WHITELIST_IP" {
  default = ["0.0.0.0/0"]
}

variable "SSH_KEY_NAME" {
    default = "infra"
}

variable "SECURITY_GROUPS_NAMES" {
  type = map
  default = {
    "web" = "web_sg"
    "rds" = "rds_sg"
    "efs" = "efs_sg"
  }
}

########################
#### RDS Parameters ####
########################

variable "RDS_NAME" {
  default = "cloud-db"
}

variable "DB_INSTANCE_TYPE" {
  default= "db.t2.micro"
}

variable "DB_NAME" {
  default = "demo"
}

variable "DATABASE_CREDENTIALS" {
  type = map
  default = {
    "username"  = "innired"
    "password" = "gettingBorred123"
  }
}