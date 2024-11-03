resource "azurerm_cosmosdb_account" "cosmosdb" {
  name                = "cosmosdb-brs-teentrego-${var.env}"
  location            = var.region
  resource_group_name = var.resource_group_name
  offer_type          = "Standard"             
  kind                = "GlobalDocumentDB"     
  consistency_policy {
    consistency_level = "Session"
  }
  geo_location {
    location          = var.region
    failover_priority = 0
  }
  capabilities {
    name = "EnableServerless"
  }
}


resource "azurerm_private_endpoint" "cosmosdb_private_endpoint" {
  count               = var.create_private_endpoint ? 1 : 0
  name                = "pep-brs-teentrego-cosmos-${var.env}"
  location            = var.region
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "cosmosdbConnection"
    private_connection_resource_id = azurerm_cosmosdb_account.cosmosdb.id
    subresource_names              = ["Sql"]  # Mude para "Sql" para Cosmos DB clássico
    is_manual_connection           = false
  }
}
