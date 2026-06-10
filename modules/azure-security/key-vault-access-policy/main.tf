resource "azurerm_key_vault_access_policy" "access_policy" {
  key_vault_id            = var.key_vault_id
  tenant_id               = var.tenant_id
  for_each                = var.kv_access_assignments
  object_id               = each.value.principal_id
  key_permissions         = each.value.key_permissions != null ? each.value.key_permissions : []
  secret_permissions      = each.value.secret_permissions != null ? each.value.secret_permissions : []
  certificate_permissions = each.value.certificate_permissions != null ? each.value.certificate_permissions : []
}