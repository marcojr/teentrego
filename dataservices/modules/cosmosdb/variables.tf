variable "env" {}
variable "resource_group_name" {}
variable "region" {}
variable "subnet_id" {}
variable "create_private_endpoint" {
  description = "Define se um Private Endpoint deve ser criado para o Cosmos DB"
  type        = bool
  default     = true
}
