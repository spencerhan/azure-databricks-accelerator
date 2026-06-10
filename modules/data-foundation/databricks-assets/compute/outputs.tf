output "cluster_id" {
  description = "The ID of the Databricks cluster"
  value       = databricks_cluster.compute.id
}

output "cluster_name" {
  description = "The name of the Databricks cluster"
  value       = databricks_cluster.compute.cluster_name
}

output "cluster_state" {
  description = "The current state of the cluster"
  value       = databricks_cluster.compute.state
}
