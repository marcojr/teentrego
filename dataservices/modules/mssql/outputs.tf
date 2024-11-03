output "sql_server_name" {
  value = azurerm_mssql_server.sql_server.name
}

output "sql_private_endpoint_id" {
  value = azurerm_private_endpoint.sql_private_endpoint.id
} 