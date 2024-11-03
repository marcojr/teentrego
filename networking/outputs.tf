output "vnet_id" {
  value = module.vnet.vnet_id
}

output "app_subnet_id" {
  value = module.app_subnet.subnet_id
}

output "data_subnet_id" {
  value = module.data_subnet.subnet_id
}

output "ml_subnet_id" {
  value = module.ml_subnet.subnet_id
}

output "firewall_id" {
  value = module.firewall.firewall_id
}

output "vpn_gateway_id" {
  value = module.vpn_gateway.vpn_gateway_id
}
