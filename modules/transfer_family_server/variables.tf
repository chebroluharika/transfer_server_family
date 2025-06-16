variable "sftp_users" {
  type = map(object({
    ssh_key_path = string
  }))
  description = "Map of SFTP usernames to their SSH public key file paths"
}


variable "home_directory" {
  description = "Home directory path for the SFTP users"
  type        = string
  default     = "/april-easyinvoice-sftp-bucket/easyinvoice"
}

variable "endpoint_type" {
  default = "VPC"
  type = string
}

variable "vpc_id" {
  default = ""
  type = string
}

variable "subnet_ids" {
  default = []
  type = list(string)
}
