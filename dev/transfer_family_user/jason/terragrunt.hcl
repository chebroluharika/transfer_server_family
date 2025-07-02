include {
  path = find_in_parent_folders()
}

terraform {
  source = "../modules/transfer_family_user"
}

inputs = {
    user_name        = "jsone"
    ssh_key_paths = [
        "keys/user_key1.pub",
        "keys/user_key2.pub"
    ]
    policy_file_path = "policies/user2_policy.json"
    home_directory   = "/jsone"
    region           = "april"
    project          = "easyinvoice"
    enable_upload = true
    enable_delete = false
    enable_download = true
    policy_types = ["upload", "list", "delete", "download"]
}

