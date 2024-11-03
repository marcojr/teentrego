variable "name" {
  description = "Name of the VPN gateway"
  type        = string
}

variable "region" {
  description = "Azure region"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "subnet_id" {
  description = "ID of the gateway subnet"
  type        = string
}
