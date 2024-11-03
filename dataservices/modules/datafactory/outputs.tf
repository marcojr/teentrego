output "data_factory_name" {
  value = azurerm_data_factory.data_factory.name
}

output "data_factory_id" {
  value = azurerm_data_factory.data_factory.id
}

output "data_factory_private_endpoint_id" {
  value = length(azurerm_private_endpoint.data_factory_private_endpoint) > 0 ? azurerm_private_endpoint.data_factory_private_endpoint[0].id : null
  description = "ID do Private Endpoint do Data Factory, se criado"
}
