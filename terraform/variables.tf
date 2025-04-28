variable "account_id" {
  type    = string
  default = "205930636266"
}
variable "region" {
  type    = string
  default = "us-east-1"
}


# NETWOTKING VARIABLES 

variable "vpc_name" {
  type    = string
  default = "main_vpc"
}

variable "vpc_cidr" {
  type    = string
  default = "10.1.0.0/16"
}

variable "vpc_private_subnets" {
  type    = list(any)
  default = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]
}

variable "vpc_public_subnets" {
  type    = list(any)
  default = ["10.1.101.0/24", "10.1.102.0/24", "10.1.103.0/24"]
}

variable "vpc_azs" {
  type    = list(any)
  default = ["us-east-1a", "us-east-1b", "us-east-1c"]
}


## EKS VARIABLES 

variable "eks_name" {
  type    = string
  default = "weather_cluster"
}

variable "eks_version" {
  type    = string
  default = "1.32"
}