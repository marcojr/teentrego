variable "env" {
  description = "Ambiente (ex: dev, sit, prod)"
  type        = string
}

variable "resource_group_name" {
  description = "Nome do Resource Group"
  type        = string
}

variable "region" {
  description = "Região para provisionamento dos recursos"
  type        = string
}

variable "create_private_endpoint" {
  description = "Define se um Private Endpoint deve ser criado para o Data Factory"
  type        = bool
  default     = false
}

variable "subnet_id" {
  description = "ID da Subnet para o Private Endpoint do Data Factory"
  type        = string
}
