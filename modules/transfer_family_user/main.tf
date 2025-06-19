locals {
  policy_types = ["upload", "list", "delete", "download"]

  user_policy_combinations = merge([
    for user_key, user_config in var.sftp_users : {
      for policy_type in local.policy_types :
      "${user_key}-${policy_type}" => {
        user_name   = user_key
        policy_type = policy_type
      }
      if lookup(user_config, "enable_${policy_type}", false)
    }
  ]...)
}

# Create IAM role for each user
resource "aws_iam_role" "sftp_user_roles" {
  name = "dataex-${var.region}-${var.project}-${var.user_name}-sftp-role"

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

resource "aws_iam_role_policy" "sftp_user_policies" {
  for_each = local.user_policy_combinations

  name = "dataex-${var.region}-${var.project}-${each.value.user_name}-${each.value.policy_type}-sftp-policy"
  role = aws_iam_role.sftp_user_roles[each.value.user_name].id

  policy = file("${path.module}/policies/${each.value.policy_type}_policy.json")
}

# Create SFTP Users
resource "aws_transfer_user" "users" {
    depends_on = [ aws_transfer_server.sftp_server ]
    server_id      = aws_transfer_server.sftp_server.id
    user_name      = "dataex-${var.region}-${var.project}-${var.user_name}"
    role           = aws_iam_role.sftp_user_role.arn
    home_directory = var.home_directory
}

# Create SFTP SSH Keys
resource "aws_transfer_ssh_key" "ssh_keys" {
  for_each = {
    for idx, path in var.ssh_key_paths : idx => path
  }

  depends_on = [aws_transfer_user.user]

  server_id = aws_transfer_server.sftp_server.id
  user_name = "dataex-${var.region}-${var.project}-${var.user_name}"
  body      = file(each.value)
}
