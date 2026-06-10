terraform {
  required_providers {
    databricks = {
      source = "databricks/databricks"
    }
  }
}


resource "databricks_permissions" "compute_permissions" {
  instance_pool_id = var.instance_pool_id
  dynamic "access_control" {
    for_each = toset(var.access_controls)
    content {
      group_name       = access_control.value.group_name
      permission_level = access_control.value.permission_level
    }
  }
}