variable "env" {
  description = "Environment (dev, sit, prod)"
  type        = string
}

variable "region" {
  description = "Azure Region"
  type        = string
  default     = "brazilsouth"
}

variable "vnet_cidr" {
  description = "CIDR da VNet"
  default     = "10.0.0.0/16"
}

variable "app_subnet_cidr" {
  description = "CIDR da subnet de aplicativos"
  default     = "10.0.1.0/24"
}

variable "data_subnet_cidr" {
  description = "CIDR da subnet de dados"
  default     = "10.0.2.0/24"
}

variable "ml_subnet_cidr" {
  description = "CIDR da subnet de machine learning"
  default     = "10.0.3.0/24"
}

variable "firewall_subnet_cidr" {
  description = "CIDR da subnet para o Azure Firewall"
  type        = string
  default     = "10.0.4.0/24" # Exemplo, certifique-se de que está dentro do intervalo da VNet
}

variable "gateway_subnet_cidr" {
  description = "CIDR da subnet para o VPN Gateway"
  type        = string
  default     = "10.0.5.0/24" # Certifique-se de que está dentro do intervalo da VNet
}




variable "firewall_policy" {
  description = "Firewall policy for Azure Firewall"
  type        = string
}
variable "resource_group_name" {
  description = "Nome do grupo de recursos onde os recursos serão criados"
  type        = string
}