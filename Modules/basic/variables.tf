variable "region" {
  type    = string
  default = "us-east-1"
}

variable "name" {
  default = "drk-s3-bucket"
}

variable "acl" {
  type    = string
  default = "private"

}