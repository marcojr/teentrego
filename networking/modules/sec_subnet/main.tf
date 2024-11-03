# Definição da Subnet de Segurança para o Key Vault
resource "azurerm_subnet" "sec_subnet" {
  name                 = var.name
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.vnet_name
  address_prefixes     = [var.address_space]

  # Configura o Service Endpoint para Microsoft.KeyVault
  service_endpoints = ["Microsoft.KeyVault"]
}
 