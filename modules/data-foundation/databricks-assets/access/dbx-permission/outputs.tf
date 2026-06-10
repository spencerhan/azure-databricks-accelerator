output "compute_permissions_ids" {
  description = "IDs of the Databricks permissions assigned to the instance pool"
  value       = databricks_permissions.compute_permissions.id
}

output "compute_permissions_instance_pool_id" {
  description = "ID of the Databricks instance pool that the permissions are assigned to"
  value       = databricks_permissions.compute_permissions.instance_pool_id
}