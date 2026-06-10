terraform {
  required_providers {
    databricks = {
      source = "databricks/databricks"
    }
  }
}

resource "databricks_cluster" "compute" {
  cluster_name       = var.cluster_name
  spark_version      = var.databricks_cluster_conf.spark_version
  node_type_id       = var.databricks_cluster_conf.node_type_id
  runtime_engine     = var.databricks_cluster_conf.runtime_engine
  num_workers        = var.databricks_cluster_conf.num_workers
  data_security_mode = var.databricks_cluster_conf.data_security_mode
  single_user_name   = var.user_group
  kind               = var.databricks_cluster_conf.kind
  is_single_node     = true
  # Spark configuration (merged with single-node profile flag)
  spark_conf  = var.spark_conf
  custom_tags = var.custom_tags

  # Optional but strongly recommended for interactive clusters:
  autotermination_minutes = var.autotermination_minutes
}
