output "instance_pool_id" {
  description = "ID of the Databricks instance pool"
  value       = databricks_instance_pool.hps_clinical_notes_pool.id
}

output "instance_pool_name" {
  description = "Name of the Databricks instance pool"
  value       = databricks_instance_pool.hps_clinical_notes_pool.instance_pool_name
}

output "instance_pool_node_type_id" {
  description = "Node type ID of the Databricks instance pool"
  value       = databricks_instance_pool.hps_clinical_notes_pool.node_type_id
}