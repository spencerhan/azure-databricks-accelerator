terraform {
  required_providers {
    databricks = {
      source = "databricks/databricks"
    }
  }
}


resource "databricks_instance_pool" "hps_clinical_notes_pool" {
  instance_pool_name                    = var.instance_pool_name
  min_idle_instances                    = 1
  max_capacity                          = 1
  node_type_id                          = var.node_type_id
  idle_instance_autotermination_minutes = 60

  preloaded_spark_versions = toset(var.preloaded_spark_versions)

  azure_attributes {
    availability       = "ON_DEMAND_AZURE"
    spot_bid_max_price = -1
  }
  custom_tags = var.custom_tags
}



module "pool_permissions" {
  source = "../access/dbx-permission"

  instance_pool_id = databricks_instance_pool.hps_clinical_notes_pool.id

  access_controls = var.access_controls
  providers = {
    databricks = databricks
  }
}