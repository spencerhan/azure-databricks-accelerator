
resource "azurerm_resource_group" "rg" {
  name     = var.rg_name
  location = var.rg_location
  tags     = var.tags

}


module "resource_lock" {
  source        = "../../azure-governance/resource-lock"
  count         = var.enable_lock ? 1 : 0
  resource_id   = azurerm_resource_group.rg.id
  resource_name = azurerm_resource_group.rg.name
  lock_level    = "CanNotDelete"
  lock_notes    = "Prevent accidental deletion of the resource group"
}


module "role_assignment" {
  source      = "../../azure-governance/role-assignment"
  scope       = azurerm_resource_group.rg.id
  assignments = var.role_assignments != null ? var.role_assignments : {}
}
