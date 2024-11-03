output "blob_storage_account_name" {
  value = azurerm_storage_account.blob_storage.name
}

output "blob_private_endpoint_id" {
  value = azurerm_private_endpoint.blob_private_endpoint.id
}
