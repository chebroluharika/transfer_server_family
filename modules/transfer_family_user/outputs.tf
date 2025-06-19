output "user_arns" {
  description = "Map of usernames to their Transfer Family user ARNs"
  value = {
    for username, user in aws_transfer_user.users :
    username => user.arn
  }
}