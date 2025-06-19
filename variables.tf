variable "sftp_users" {
  description = "Map of SFTP users and their SSH key and policy"
  type = map(object({
    ssh_key_paths     = list(string)
    policy_file_path  = string
    region            = string
    project           = string
    enable_upload   = bool
    enable_list     = bool
    enable_delete   = bool
    enable_download = bool
  }))
}

variable "vpc_id" {
  default = ""
  type = string
}

variable "subnet_ids" {
  default = []
  type = list(string)
}

variable "log_group_timestamp" {
  description = "Timestamp suffix for log group name"
  type        = string
}

variable "transfer_server_name" {
  default = "Test-terraform"
  type = string
}
