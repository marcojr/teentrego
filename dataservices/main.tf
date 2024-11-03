terraform {
  backend "azurerm" {}
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

# Referência ao Resource Group existente
data "azurerm_resource_group" "rg" {
  name = "rg-teentrego-${var.env}"
}

# Referência à VNet existente
data "azurerm_virtual_network" "vnet" {
  name                = "vnet-brs-teentrego-${var.env}"
  resource_group_name = data.azurerm_resource_group.rg.name
}

# Referência à Subnet de Dados existente
data "azurerm_subnet" "data_subnet" {
  name                 = "snet-brs-teentrego-data-${var.env}"
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  resource_group_name  = data.azurerm_resource_group.rg.name
}

# Obtenção de credenciais do Key Vault
data "azurerm_key_vault" "key_vault" {
  name                = "kva-brs-teentrego-${var.env}"
  resource_group_name = data.azurerm_resource_group.rg.name
}

data "azurerm_key_vault_secret" "sql_admin_username" {
  name         = "sql-admin-username"
  key_vault_id = data.azurerm_key_vault.key_vault.id
}

data "azurerm_key_vault_secret" "sql_admin_password" {
  name         = "sql-admin-password"
  key_vault_id = data.azurerm_key_vault.key_vault.id
}

data "azurerm_key_vault_secret" "synapse_admin_username" {
  name         = "synapse-admin-username"
  key_vault_id = data.azurerm_key_vault.key_vault.id
}

data "azurerm_key_vault_secret" "synapse_admin_password" {
  name         = "synapse-admin-password"
  key_vault_id = data.azurerm_key_vault.key_vault.id
}

# Provisionamento do SQL Server
module "sql_database" {
  source              = "./modules/mssql"
  env                 = var.env
  resource_group_name = data.azurerm_resource_group.rg.name
  region              = var.region
  admin_username      = data.azurerm_key_vault_secret.sql_admin_username.value
  admin_password      = data.azurerm_key_vault_secret.sql_admin_password.value
  subnet_id           = data.azurerm_subnet.data_subnet.id
}

# Provisionamento do Cosmos DB
module "cosmosdb" {
  source              = "./modules/cosmosdb"
  env                 = var.env
  resource_group_name = data.azurerm_resource_group.rg.name
  region              = var.region
  subnet_id           = data.azurerm_subnet.data_subnet.id
}

# Provisionamento do Data Lake Storage
module "data_lake" {
  source              = "./modules/datalake"
  env                 = var.env
  resource_group_name = data.azurerm_resource_group.rg.name
  region              = var.region
  subnet_id           = data.azurerm_subnet.data_subnet.id
}

# Provisionamento do Blob Storage
module "blob_storage" {
  source              = "./modules/blob"
  env                 = var.env
  resource_group_name = data.azurerm_resource_group.rg.name
  region              = var.region
  subnet_id           = data.azurerm_subnet.data_subnet.id
}

# Provisionamento do Synapse
module "synapse" {
  source                   = "./modules/synapse"
  env                      = var.env
  resource_group_name      = data.azurerm_resource_group.rg.name
  region                   = var.region
  admin_username           = data.azurerm_key_vault_secret.synapse_admin_username.value
  admin_password           = data.azurerm_key_vault_secret.synapse_admin_password.value
  data_lake_filesystem_id  =  module.data_lake.data_lake_storage_account_filesystem_id
  subnet_id                = data.azurerm_subnet.data_subnet.id
}


# Provisionamento do Event Hub
module "event_hub" {
  source              = "./modules/eventhub"
  env                 = var.env
  resource_group_name = data.azurerm_resource_group.rg.name
  region              = var.region
  subnet_id           = data.azurerm_subnet.data_subnet.id
}

# Provisionamento do Data Factory
module "data_factory" {
  source              = "./modules/datafactory"
  env                 = var.env
  resource_group_name = data.azurerm_resource_group.rg.name
  region              = var.region
  subnet_id           = data.azurerm_subnet.data_subnet.id
}
