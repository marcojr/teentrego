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

variable "subnet_id" {
  description = "ID da Subnet para o Private Endpoint do Event Hub"
  type        = string
}

variable "partition_count" {
  description = "Número de partições para o Event Hub"
  type        = number
  default     = 2
}

variable "message_retention" {
  description = "Período de retenção de mensagens no Event Hub em dias"
  type        = number
  default     = 1
}
