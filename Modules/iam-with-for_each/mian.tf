resource "aws_iam_user" "example" {
  for_each = toset(var.user_names)
  name  = each.value
}

variable "user_names" {
  description = "Create IAM users with these names"
  type        = list(string)
  default     = ["neo", "trinity", "morpheus"]
}

output "all_users" {
  value       = aws_iam_user.example
  description = "all attiributes of the created IAM users"
}

output "all_arns" {
  value = values(aws_iam_user.example)[*].arn
  description = "The ARNs of the created IAM users"
}
