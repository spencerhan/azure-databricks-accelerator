
resource "azurerm_key_vault" "kv" {
  name                       = var.kv_name
  location                   = var.location
  resource_group_name        = var.resource_group_name
  tenant_id                  = var.tenant_id
  sku_name                   = var.kv_sku_name
  soft_delete_retention_days = var.kv_soft_delete_retention_days
  purge_protection_enabled   = var.kv_purge_protection_enabled

  rbac_authorization_enabled = var.rbac_authorization_enabled

  public_network_access_enabled = var.public_network_access_enabled

  # when PNA is false, network_acls is ignored for public traffic

  dynamic "network_acls" {
    for_each = var.public_network_access_enabled && var.network_acls != null ? [var.network_acls] : []
    content {
      default_action             = network_acls.value.default_action
      bypass                     = network_acls.value.bypass
      ip_rules                   = toset(network_acls.value.ip_rules)
      virtual_network_subnet_ids = toset(network_acls.value.virtual_network_subnet_ids)
    }
  }

  tags = var.tags
}

module "role_assignment" {
  source      = "../../azure-governance/role-assignment"
  scope       = azurerm_key_vault.kv.id
  assignments = var.kv_role_assignments != null ? var.kv_role_assignments : {}
}


module "kv_access_policy" {
  source                = "../../azure-security/key-vault-access-policy"
  key_vault_id          = azurerm_key_vault.kv.id
  tenant_id             = azurerm_key_vault.kv.tenant_id
  kv_access_assignments = var.kv_access_assignments
}