terraform {
  required_providers {
    databricks = {
      source = "databricks/databricks"
    }
  }
}


resource "databricks_group" "wks_user_groups" {
  for_each     = var.groups
  display_name = each.value.display_name
  external_id  = each.value.object_id
}