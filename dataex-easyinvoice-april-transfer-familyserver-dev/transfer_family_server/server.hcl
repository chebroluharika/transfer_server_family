
include {
  path = find_in_parent_folders()
}

terraform {
  source = "git::https://github.com/RGE-Digital/terraform-module-aws-transfer-server.git//transfer-family-server?ref=terraform-module-aws-transfer-server"
}

inputs = {
    log_group_timestamp =  ""
    transfer_server_name = "Test-terraform"
    subnet_ids = ["subnet-0026b807c26af61bd", "subnet-012f7d74fb7832e09"]
    vpc_id = "vpc-0fb9fcfc894331bed"  
}
