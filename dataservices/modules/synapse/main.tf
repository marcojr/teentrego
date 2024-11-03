resource "azurerm_synapse_workspace" "synapse" {
  name                                = "synapse-brs-teentrego-${var.env}"
  resource_group_name                 = var.resource_group_name
  location                            = var.region
  storage_data_lake_gen2_filesystem_id = var.data_lake_filesystem_id
  sql_administrator_login              = var.admin_username
  sql_administrator_login_password     = var.admin_password
  identity {
    type = "SystemAssigned"
  }
}


# Private Endpoint para SQL On-Demand
resource "azurerm_private_endpoint" "synapse_sqlOnDemand_private_endpoint" {
  count               = var.create_private_endpoint ? 1 : 0
  name                = "pep-brs-teentrego-synapse-sqlOnDemand-${var.env}"
  location            = var.region
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "synapseSqlOnDemandConnection"
    private_connection_resource_id = azurerm_synapse_workspace.synapse.id
    subresource_names              = ["sqlOnDemand"]
    is_manual_connection           = false
  }
}

# Private Endpoint para Dev
resource "azurerm_private_endpoint" "synapse_dev_private_endpoint" {
  count               = var.create_private_endpoint ? 1 : 0
  name                = "pep-brs-teentrego-synapse-dev-${var.env}"
  location            = var.region
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "synapseDevConnection"
    private_connection_resource_id = azurerm_synapse_workspace.synapse.id
    subresource_names              = ["dev"]
    is_manual_connection           = false
  }
}
