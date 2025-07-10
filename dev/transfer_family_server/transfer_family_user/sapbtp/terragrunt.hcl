include {
  path = find_in_parent_folders()
}

dependency "transfer_family_server" {
  config_path = "../../transfer_family_server"
}

terraform {
  source = "git::https://github.com/RGE-Digital/terraform-module-aws-transfer-server.git//transfer-family-user?ref=terraform-module-aws-transfer-server"
}

inputs = {
    user_name        = "sapbtp"
    ssh_key_paths = [
        "keys/key1.pub",
    ]
    policy_file_path = "policies/user2_policy.json"
    home_directory   = "/sapbtp"
    region           = "april"
    project          = "easyinvoice"
    enable_upload = true
    enable_delete = false
    enable_download = true
    policy_types = ["upload", "list", "delete", "download"]
    server_id = dependency.transfer_family_server.outputs.server_id
}
