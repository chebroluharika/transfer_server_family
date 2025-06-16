# AWS Transfer Server
resource "aws_transfer_server" "sftp_server" {
  endpoint_type = var.endpoint_type

  endpoint_details {
    subnet_ids = var.subnet_ids
    vpc_id = var.vpc_id
  }

  protocols = ["SFTP"]

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
