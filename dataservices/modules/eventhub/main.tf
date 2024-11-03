# Event Hub Namespace
resource "azurerm_eventhub_namespace" "namespace" {
  name                = "evhns-brs-teentrego-${var.env}"
  location            = var.region
  resource_group_name = var.resource_group_name
  sku                 = "Standard"
  capacity            = 1
  depends_on          = [var.subnet_id]
}

# Event Hub dentro do Namespace
resource "azurerm_eventhub" "eventhub" {
  name                = "eventhub-brs-teentrego-${var.env}"
  namespace_name      = azurerm_eventhub_namespace.namespace.name
  resource_group_name = var.resource_group_name
  partition_count     = var.partition_count
  message_retention   = var.message_retention
}

# Private Endpoint para Event Hub Namespace
resource "azurerm_private_endpoint" "eventhub_private_endpoint" {
  name                = "pep-brs-teentrego-eventhub-${var.env}"
  location            = var.region
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "eventHubConnection"
    private_connection_resource_id = azurerm_eventhub_namespace.namespace.id
    subresource_names              = ["namespace"]
    is_manual_connection           = false
  }
}
