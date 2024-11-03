# Criação do Key Vault
resource "azurerm_key_vault" "keyvault" {
  name                        = "kva-brs-teentrego-${var.env}"
  location                    = var.region
  resource_group_name         = var.resource_group_name
  tenant_id                   = var.tenant_id
  sku_name                    = "standard"
  purge_protection_enabled    = false
  enabled_for_disk_encryption = true
  enable_rbac_authorization   = true  # Habilita o modelo RBAC

  network_acls {
    default_action             = "Deny"
    bypass                     = "AzureServices"
    virtual_network_subnet_ids = var.allowed_subnet_ids
  }
}

# Atribuição de função para o administrador no Key Vault usando RBAC
resource "azurerm_role_assignment" "kv_admin_role" {
  principal_id         = var.admin_object_id           # Object ID do administrador
  role_definition_name = "Key Vault Administrator"     # Papel para permissões de administrador no Key Vault
  scope                = azurerm_key_vault.keyvault.id # Define o escopo como o Key Vault recém-criado
}

# Definir Segredos Opcionalmente
resource "azurerm_key_vault_secret" "secrets" {
  count      = length(var.secrets)
  name       = var.secrets[count.index].name
  value      = var.secrets[count.index].value
  key_vault_id = azurerm_key_vault.keyvault.id
}
