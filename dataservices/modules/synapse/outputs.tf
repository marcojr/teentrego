output "synapse_workspace_name" {
  value = azurerm_synapse_workspace.synapse.name
}

output "synapse_sqlOnDemand_private_endpoint_id" {
  value = length(azurerm_private_endpoint.synapse_sqlOnDemand_private_endpoint) > 0 ? azurerm_private_endpoint.synapse_sqlOnDemand_private_endpoint[0].id : null
  description = "ID do Private Endpoint para SQL On-Demand"
}

output "synapse_dev_private_endpoint_id" {
  value = length(azurerm_private_endpoint.synapse_dev_private_endpoint) > 0 ? azurerm_private_endpoint.synapse_dev_private_endpoint[0].id : null
  description = "ID do Private Endpoint para Dev"
}

