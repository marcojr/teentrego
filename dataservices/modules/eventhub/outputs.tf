output "eventhub_namespace_name" {
  value = azurerm_eventhub_namespace.namespace.name
}

output "eventhub_name" {
  value = azurerm_eventhub.eventhub.name
}

output "eventhub_private_endpoint_id" {
  value = azurerm_private_endpoint.eventhub_private_endpoint.id
}
