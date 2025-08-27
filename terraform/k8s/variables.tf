variable "account_id" {
  type    = string
  default = "205930636266"
}
variable "region" {
  type    = string
  default = "us-east-1"
}
variable "image_tag" {
  type        = string
  description = "Docker image tag for both frontend & backend apps"
}
