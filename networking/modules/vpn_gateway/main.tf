resource "azurerm_virtual_network_gateway" "vpn_gateway" {
  name                = var.name
  location            = var.region
  resource_group_name = var.resource_group_name
  type                = "Vpn"
  vpn_type            = "RouteBased"
  sku                 = "VpnGw2"

  ip_configuration {
    name                          = "vpnconfig"
    public_ip_address_id          = azurerm_public_ip.vpn_public_ip.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = var.subnet_id 
  }
}



resource "azurerm_public_ip" "vpn_public_ip" {
  name                = "pip-${var.name}"
  location            = var.region
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
}
