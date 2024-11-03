terraform {
  backend "azurerm" {}
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}



# Create RG
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.region
}

# Provision VNet
module "vnet" {
  source              = "./modules/vnet"
  name                = "vnet-brs-teentrego-${var.env}"
  region              = var.region
  cidr                = var.vnet_cidr
  resource_group_name = azurerm_resource_group.rg.name
}

# Provision Subnets
module "app_subnet" {
  source              = "./modules/subnet"
  name                = "snet-brs-teentrego-app-${var.env}"
  vnet_name           = module.vnet.vnet_name
  address_space       = var.app_subnet_cidr
  resource_group_name = azurerm_resource_group.rg.name
  depends_on          = [module.vnet]
}

module "data_subnet" {
  source              = "./modules/subnet"
  name                = "snet-brs-teentrego-data-${var.env}"
  vnet_name           = module.vnet.vnet_name
  address_space       = var.data_subnet_cidr
  resource_group_name = azurerm_resource_group.rg.name
  depends_on          = [module.vnet]
}

module "ml_subnet" {
  source              = "./modules/subnet"
  name                = "snet-brs-teentrego-ml-${var.env}"
  vnet_name           = module.vnet.vnet_name
  address_space       = var.ml_subnet_cidr
  resource_group_name = azurerm_resource_group.rg.name
  depends_on          = [module.vnet]
}

# Criação da Subnet dedicada para o Key Vault
module "sec_subnet" {
  source              = "./modules/sec_subnet"
  name                = "snet-brs-teentrego-sec-${var.env}"
  vnet_name           = module.vnet.vnet_name
  address_space       = var.sec_subnet_cidr  # Prefixo de IP específico para a subnet de segurança
  resource_group_name = azurerm_resource_group.rg.name
  service_endpoints   = ["Microsoft.KeyVault"]  # Adiciona o Service Endpoint para Key Vault
  depends_on          = [module.vnet]
} 

# Subnet para o Azure Firewall
module "firewall_subnet" {
  source              = "./modules/subnet"
  name                = "AzureFirewallSubnet" 
  vnet_name           = module.vnet.vnet_name
  address_space       = var.firewall_subnet_cidr 
  resource_group_name = azurerm_resource_group.rg.name
  depends_on          = [module.vnet]
}

# Subnet para o VPN Gateway
module "gateway_subnet" {
  source              = "./modules/subnet"
  name                = "GatewaySubnet" 
  vnet_name           = module.vnet.vnet_name
  address_space       = var.gateway_subnet_cidr 
  resource_group_name = azurerm_resource_group.rg.name
  depends_on          = [module.vnet]
}




# Firewall Policy
resource "azurerm_firewall_policy" "example" {
  name                = "example-firewall-policy"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.region

  depends_on = [azurerm_resource_group.rg]
}

# Public IP for Firewall
resource "azurerm_public_ip" "public_ip" {
  name                = "pip-brs-teentrego-fw-${var.env}"
  location            = var.region
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Provision Firewall
module "firewall" {
  source              = "./modules/firewall"
  name                = "fw-brs-teentrego-${var.env}"
  subnet_id           = module.firewall_subnet.subnet_id 
  region              = var.region
  firewall_policy     = azurerm_firewall_policy.example.id
  public_ip_id        = azurerm_public_ip.public_ip.id
  resource_group_name = azurerm_resource_group.rg.name
  ip_name             = "pip-brs-teentrego-fw-${var.env}"

  depends_on = [
    azurerm_resource_group.rg,
    azurerm_firewall_policy.example,
    module.firewall_subnet,
    azurerm_public_ip.public_ip
  ]
}

module "keyvault" {
  source                = "./modules/keyvault"
  env                   = var.env
  resource_group_name   = azurerm_resource_group.rg.name
  region                = var.region
  tenant_id             = var.tenant_id
  admin_object_id       = var.admin_object_id
  allowed_subnet_ids    = [module.sec_subnet.subnet_id]  # Permitir apenas a nova subnet de segurança

  depends_on = [
    azurerm_resource_group.rg
  ]
}


# Provision VPN Gateway
module "vpn_gateway" {
  source              = "./modules/vpn_gateway"
  name                = "vpngw-brs-teentrego-${var.env}"
  subnet_id           = module.gateway_subnet.subnet_id # Passe o subnet_id para o VPN Gateway
  region              = var.region
  resource_group_name = azurerm_resource_group.rg.name

  depends_on = [
    azurerm_resource_group.rg,
    module.gateway_subnet
  ]
}

