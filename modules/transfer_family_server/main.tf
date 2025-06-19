resource "aws_cloudwatch_log_group" "transfer" {
  name = "${var.transfer_server_name}-loggroup-${var.log_group_timestamp}"
  retention_in_days = var.retention_in_days
}

resource "aws_iam_role" "iam_for_transfer" {
  name_prefix         = "iam_role_for_transfer_${var.transfer_server_name}"
  assume_role_policy  = data.aws_iam_policy_document.transfer_assume_role.json
  managed_policy_arns = ["arn:aws:iam::aws:policy/service-role/AWSTransferLoggingAccess"]
}


# AWS Transfer Server
resource "aws_transfer_server" "sftp_server" {
  endpoint_type = var.endpoint_type
  logging_role  = aws_iam_role.iam_for_transfer.arn

  endpoint_details {
    subnet_ids = var.subnet_ids
    vpc_id = var.vpc_id
  }

  protocols = ["SFTP"]

  structured_log_destinations = [
    "${aws_cloudwatch_log_group.transfer.arn}:*"
  ]

  tags = {
    Name = var.transfer_server_name
  }
}
