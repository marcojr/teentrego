variable "name" {
  description = "The name of the firewall"
  type        = string
}

variable "ip_name" {
  description = "The name of the firewall"
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
  description = "ID of the subnet for the firewall"
  type        = string
}

variable "firewall_policy" {
  description = "Firewall policy for Azure Firewall"
  type        = string
}

variable "public_ip_id" {
  description = "ID do IP público a ser associado ao firewall"
  type        = string
}
