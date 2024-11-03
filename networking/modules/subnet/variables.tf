variable "name" {
  description = "Name of the subnet"
  type        = string
}

variable "vnet_name" {
  description = "Name of the VNet the subnet is attached to"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "address_space" {
  description = "CIDR block for the subnet"
  type        = string
}
