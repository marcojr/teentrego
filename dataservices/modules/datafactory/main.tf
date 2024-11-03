# Azure Data Factory
resource "azurerm_data_factory" "data_factory" {
  name                = "adf-brs-teentrego-${var.env}"
  location            = var.region
  resource_group_name = var.resource_group_name
}

# Private Endpoint para Data Factory (opcional)
resource "azurerm_private_endpoint" "data_factory_private_endpoint" {
  count               = var.create_private_endpoint ? 1 : 0
  name                = "pep-brs-teentrego-adf-${var.env}"
  location            = var.region
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "dataFactoryConnection"
    private_connection_resource_id = azurerm_data_factory.data_factory.id
    subresource_names              = ["dataFactory"]
    is_manual_connection           = false
  }
}
