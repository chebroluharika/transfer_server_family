output "user_arns" {
  description = "Map of usernames to their Transfer Family user ARNs"
  value = aws_transfer_user.users.arn
}

