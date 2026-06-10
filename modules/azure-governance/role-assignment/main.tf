resource "azurerm_role_assignment" "role_assignment" {
  scope                = var.scope
  for_each             = var.assignments
  principal_id         = each.value.principal_id
  role_definition_name = each.value.role_definition_name
  description          = try(each.value.description, null)
}