resource "azurerm_storage_account" "blob_storage" {
  name                     = "blobbrsteentrego${var.env}"
  resource_group_name      = var.resource_group_name
  location                 = var.region
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_private_endpoint" "blob_private_endpoint" {
  name                = "pep-brs-teentrego-blob-${var.env}"
  location            = var.region
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "blobConnection"
    private_connection_resource_id = azurerm_storage_account.blob_storage.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }
}
