output "wks_user_group_ids" {
  description = "IDs of the created Databricks groups for workspace users."
  value       = { for k, v in databricks_group.wks_user_groups : k => v.id }
}