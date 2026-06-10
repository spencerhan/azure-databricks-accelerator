output "dbx_wks_permission_assignment_ids" {
  description = "IDs of the created role assignments."
  value       = { for k, v in databricks_mws_permission_assignment.permission_assignment : k => v.id }
}
