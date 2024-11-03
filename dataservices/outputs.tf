# SQL Database Outputs
output "sql_server_name" {
  value = module.sql_database.sql_server_name
}

# Cosmos DB Outputs
output "cosmosdb_account_name" {
  value = module.cosmosdb.cosmosdb_account_name
}

# Data Lake Outputs
output "data_lake_storage_account_name" {
  value = module.data_lake.data_lake_storage_account_name
}

# Blob Storage Outputs
output "blob_storage_account_name" {
  value = module.blob_storage.blob_storage_account_name
}

# Synapse Outputs
output "synapse_workspace_name" {
  value = module.synapse.synapse_workspace_name
}

# Event Hub Outputs
output "eventhub_namespace_name" {
  value = module.event_hub.eventhub_namespace_name
}

# Data Factory Outputs
output "data_factory_name" {
  value = module.data_factory.data_factory_name
}
