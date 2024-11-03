variable "subscription_id" {
  description = "ID da Assinatura do Azure"
  type        = string
}

variable "env" {
  description = "Ambiente (ex: dev, sit, prod)"
  type        = string
}

variable "region" {
  description = "Região para provisionamento dos recursos"
  type        = string
}

variable "resource_group_name" {
  description = "Nome do grupo de recursos onde os recursos serão criados"
  type        = string
}
