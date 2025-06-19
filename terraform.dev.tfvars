sftp_users = {
  "jsone" = {
    ssh_key_path     = "keys/user1.pub"
    policy_file_path = "policies/user1_policy.json"
  },
  "jsonb" = {
    ssh_key_path     = "keys/user2.pub"
    policy_file_path = "policies/user2_policy.json"
  }

}
transfer_server_name = "Test-terraform"
subnet_ids = ["subnet-0026b807c26af61bd", "subnet-012f7d74fb7832e09"]
vpc_id = "vpc-0fb9fcfc894331bed"