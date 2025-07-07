output "server_endpoint" {
  description = "The endpoint of the Transfer Server"
  value = aws_transfer_server.sftp_server.endpoint
}

output "server_id" {
  description = "The endpoint of the Transfer Server"
  value = aws_transfer_server.sftp_server.id
}
