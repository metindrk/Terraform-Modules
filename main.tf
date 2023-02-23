terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>4.0"
    }
  }
}

provider "aws" {
  region = var.region
  #   profile = "mtn"
}

resource "aws_s3_bucket" "myBucket" {
  bucket = var.name
}

resource "aws_s3_bucket_acl" "myBucket" {
  bucket = aws_s3_bucket.myBucket.bucket
  acl    = var.acl
}