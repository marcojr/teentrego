output "subnet_id" {
  description = "ID da subnet de segurança para o Key Vault"
  value       = azurerm_subnet.sec_subnet.id
}

output "subnet_name" {
  description = "Nome da subnet de segurança para o Key Vault"
  value       = azurerm_subnet.sec_subnet.name
}
