output "role_assignment_ids" {
  description = "IDs of the created role assignments."
  value       = { for k, v in azurerm_role_assignment.role_assignment : k => v.id }
}
