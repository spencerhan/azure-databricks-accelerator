output "assigned_principal_ids" {
  value = keys(local.dbx_wks_permission_assignments)
}
