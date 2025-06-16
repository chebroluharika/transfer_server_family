module "sftp_users" {
  source = "./modules/transfer_family_server"

  sftp_users = {
    "sftp-user" = {
      ssh_key_path = "~/.ssh/id_rsa.pub"
    },
    "jsone" = {
      ssh_key_path = "~/.ssh/jsone_id_ed25519.pub"
    }
  }

  subnet_ids = ["subnet-0026b807c26af61bd", "subnet-012f7d74fb7832e09"]
  vpc_id = "vpc-0fb9fcfc894331bed"
}
