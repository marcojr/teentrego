output "cosmosdb_account_name" {
  value = azurerm_cosmosdb_account.cosmosdb.name
}

output "cosmosdb_private_endpoint_id" {
  value = length(azurerm_private_endpoint.cosmosdb_private_endpoint) > 0 ? azurerm_private_endpoint.cosmosdb_private_endpoint[0].id : null
  description = "ID do Private Endpoint do Cosmos DB, se criado"
}

