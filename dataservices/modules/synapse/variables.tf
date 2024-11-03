variable "env" {}
variable "resource_group_name" {}
variable "region" {}
variable "admin_username" {}
variable "admin_password" {}
variable "subnet_id" {}
variable "data_lake_filesystem_id" {
  description = "ID do sistema de arquivos do Data Lake Storage"
  type        = string
}
variable "create_private_endpoint" {
  description = "Define se um Private Endpoint deve ser criado para o Synapse"
  type        = bool
  default     = true
}
