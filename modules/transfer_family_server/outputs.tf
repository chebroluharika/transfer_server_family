output "user_arns" {
  description = "Map of usernames to their Transfer Family user ARNs"
  value = {
    for username, user in aws_transfer_user.users :
    username => user.arn
  }
}

output "server_endpoint" {
  description = "The endpoint of the Transfer Server"
  value = aws_transfer_server.sftp_server.endpoint
}
