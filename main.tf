module "sftp_users" {
  for_each = var.sftp_users
  source   = "./modules/transfer_family_user"

  user_name        = each.key
  ssh_key_paths = [
    "keys/user_key1.pub",
    "keys/user_key2.pub"
  ]
  policy_file_path = each.value.policy_file_path
  home_directory   = "/${each.key}"
  region           = each.region
  project          = each.project
  enable_upload = each.enable_upload
  enable_delete = each.enable_delete
  enable_download = each.enable_download
  sftp_users = var.sftp_users
  policy_types = ["upload", "list", "delete", "download"]
}

module "sftp_server" {
  source   = "./modules/transfer_family_server"

  subnet_ids = var.subnet_ids
  vpc_id = var.vpc_id
  transfer_server_name = var.transfer_server_name
  log_group_timestamp =  var.log_group_timestamp
}
