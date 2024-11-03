resource "azurerm_storage_account" "data_lake" {
  name                     = "datalakebrsteentrego${var.env}"
  resource_group_name      = var.resource_group_name
  location                 = var.region
  account_tier             = "Standard"
  account_replication_type = "LRS"
  is_hns_enabled           = true
}

resource "azurerm_private_endpoint" "datalake_private_endpoint" {
  name                = "pep-brs-teentrego-datalake-${var.env}"
  location            = var.region
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "dataLakeConnection"
    private_connection_resource_id = azurerm_storage_account.data_lake.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }
}

resource "azurerm_storage_data_lake_gen2_filesystem" "example" {
  name               = "filesystem"
  storage_account_id = azurerm_storage_account.data_lake.id
}
