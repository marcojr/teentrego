variable "env" {
  description = "Ambiente (ex: dev, sit, prod)"
  type        = string
}

variable "resource_group_name" {
  description = "Nome do Resource Group"
  type        = string
}

variable "region" {
  description = "Região para provisionamento do Key Vault"
  type        = string
}

variable "tenant_id" {
  description = "ID do Tenant do Azure AD"
  type        = string
}

variable "admin_object_id" {
  description = "Object ID do administrador que terá permissões no Key Vault"
  type        = string
}

variable "allowed_subnet_ids" {
  description = "Lista de IDs de subnets permitidas para acessar o Key Vault"
  type        = list(string)
  default     = []
}

variable "secrets" {
  description = "Lista opcional de segredos para serem criados no Key Vault"
  type        = list(object({
    name  = string
    value = string
  }))
  default = []
}
