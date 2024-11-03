variable "name" {
  description = "Nome da subnet de segurança para o Key Vault"
  type        = string
}

variable "resource_group_name" {
  description = "Nome do Resource Group onde a subnet será criada"
  type        = string
}

variable "vnet_name" {
  description = "Nome da VNet onde a subnet será criada"
  type        = string
}

variable "address_space" {
  description = "Prefixo de endereço (CIDR) para a subnet"
  type        = string
}

variable "service_endpoints" {
  description = "Lista de Service Endpoints a serem configurados na subnet"
  type        = list(string)
  default     = ["Microsoft.KeyVault"]
}
