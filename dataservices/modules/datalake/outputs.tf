output "data_lake_storage_account_name" {
  value = azurerm_storage_account.data_lake.name
}

output "datalake_private_endpoint_id" {
  value = azurerm_private_endpoint.datalake_private_endpoint.id
}
output "data_lake_storage_account_filesystem_id" {
  value       = azurerm_storage_data_lake_gen2_filesystem.example.id
  description = "ID do sistema de arquivos do Data Lake Storage"
}

