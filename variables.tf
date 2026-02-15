variable "aws_region" {
  type    = string
  default = "ap-northeast-2"
}

variable "name" {
  type    = string
  default = "plate"
}

variable "vpc_cidr" {
  type    = string
  default = "10.7.0.0/16"
}

variable "public_subnet_cidrs" {
  type    = list(string)
  default = ["10.7.1.0/24", "10.7.2.0/24"]
}

variable "azs" {
  type    = list(string)
  default = ["ap-northeast-2a", "ap-northeast-2c"]
}