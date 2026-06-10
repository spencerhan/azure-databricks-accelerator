terraform {
  required_providers {
    databricks = {
      source = "databricks/databricks"
    }
  }
}


resource "databricks_mws_permission_assignment" "permission_assignment" {
  for_each     = var.dbx_wks_permission_assignments
  principal_id = each.value.principal_id
  permissions  = [each.value.permission_name]
  workspace_id = var.workspace_id
}