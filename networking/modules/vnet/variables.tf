variable "name" {
  description = "The name of the VNet"
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

variable "cidr" {
  description = "CIDR block for the VNet"
  type        = string
}
