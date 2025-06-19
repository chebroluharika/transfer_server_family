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


variable "transfer_server_name" {
  default = "Test-terraform"
  type = string
}

variable "retention_in_days" {
  default = 30
  type = number
}

variable "log_group_timestamp" {
  description = "Timestamp suffix for log group name"
  type        = string
}