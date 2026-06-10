resource "azurerm_management_lock" "lock" {
  name       = "resource-lock-${var.resource_name}"
  scope      = var.resource_id
  lock_level = var.lock_level // Or "ReadOnly"
  notes      = var.lock_notes
}