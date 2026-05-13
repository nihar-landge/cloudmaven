variable "rg_name" {
  type = string
  description = "Resource group name"
  default = "null"
}

variable "storage_account_name" {
  type = string
  description = "storage account name"
  default = null
}


variable "private_container_name" {
  type = string
  description = "Private storage name"
  default = "null"
}

variable "storage_public_access" {
  type = bool
  description = "Storage account access"
  default = null
}

variable "tags" {
  type        = list(string)
  description = "A list of tags to apply to the resource"
  default     = ["dev", "test"]
}