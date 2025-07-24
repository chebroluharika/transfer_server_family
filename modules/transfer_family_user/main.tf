locals {
  user_policy_combinations = {
    for op, enabled in {
      upload   = var.enable_upload
      download = var.enable_download
      delete   = var.enable_delete
    } : 
    op => {
      policy_type = op
    }
    if enabled
  }
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

  name = "dataex-${var.region}-${var.project}-${var.user_name}-${each.value.policy_type}-sftp-policy"
  role = aws_iam_role.sftp_user_roles.id

  policy = templatefile("${path.module}/policies/${each.value.policy_type}_policy.json.tpl", {
    bucket_name = var.bucket_name
  })
}


# Create SFTP Users
resource "aws_transfer_user" "users" {
    server_id      = var.server_id
    user_name      = "dataex-${var.region}-${var.project}-${var.user_name}"
    role           = aws_iam_role.sftp_user_role.arn
    home_directory = var.home_directory
}

# Create SFTP SSH Keys
resource "aws_transfer_ssh_key" "ssh_keys" {
  for_each = {
    for idx, path in var.ssh_key_paths : idx => path
  }

  server_id = var.server_id
  user_name = "dataex-${var.region}-${var.project}-${var.user_name}"
  body      = file(each.value)
}
