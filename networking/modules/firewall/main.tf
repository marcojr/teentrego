resource "azurerm_firewall" "firewall" {
  name                = var.name
  location            = var.region
  resource_group_name = var.resource_group_name
  sku_name            = "AZFW_VNet"
  firewall_policy_id  = var.firewall_policy
  sku_tier            = "Standard"

  ip_configuration {
    name                 = "configuration"
    subnet_id            = var.subnet_id
    public_ip_address_id = var.public_ip_id 
  }
}