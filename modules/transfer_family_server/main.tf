resource "aws_cloudwatch_log_group" "transfer" {
  name = "/aws/transfer/Test-Terraform"
  retention_in_days = 30
}

data "aws_iam_policy_document" "transfer_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["transfer.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "iam_for_transfer" {
  name_prefix         = "iam_for_transfer_"
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
    Name = "Test-Terraform"
  }
}

# Create IAM role for each user
resource "aws_iam_role" "sftp_user_roles" {
  for_each = var.sftp_users

  name = "${each.key}-sftp-role"

  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [{
      "Effect": "Allow",
      "Principal": {
        "Service": "transfer.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "sftp_user_policy" {
  for_each = var.sftp_users

  name = "${each.key}-sftp-policy"
  role = aws_iam_role.sftp_user_roles[each.key].id

  policy = file("${path.root}/policies/${each.key}_policy.json")
}


# Create SFTP Users
resource "aws_transfer_user" "users" {
  for_each = var.sftp_users

  server_id      = aws_transfer_server.sftp_server.id
  user_name      = each.key
  role           = aws_iam_role.sftp_user_roles[each.key].arn
  home_directory = var.home_directory
}

# Create SFTP SSH Keys
resource "aws_transfer_ssh_key" "ssh_keys" {
  depends_on = [ aws_transfer_user.users ]
  for_each = var.sftp_users

  server_id = aws_transfer_server.sftp_server.id
  user_name = each.key
  body      = file(each.value.ssh_key_path)
}
