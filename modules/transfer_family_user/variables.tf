variable "home_directory" {
  description = "Home directory path for the SFTP users"
  type        = string
  default     = "/april-easyinvoice-sftp-bucket/easyinvoice"
}

variable "server_id" {
  description = "Id of the Transfer Family server"
  type        = string
}

variable "user_name" {
  type = string
}

variable "project" {
  type = string
}

variable "region" {
  type = string
}

variable "bucket_name" {
  type = string
}

variable "ssh_key_paths" {
  description = "List of SSH public key file paths for the user"
  type        = list(string)
}

variable "policy_file_path" {
  type = string
}

variable "enable_upload" {
  default = false
  type = bool
}

variable "enable_download" {
    default = false
    type = boolean
}

variable "enable_delete" {
    default = false
    type = boolean
}

variable "policy_types" {
  default = ["list"]
  type = list()
}
