module "dbx_wks_role_assignment" {
  source                         = "../../../modules/data-foundation/databricks-assets/access/wks-permission-assignment"
  dbx_wks_permission_assignments = local.dbx_wks_permission_assignments
  workspace_id                   = local.workspace_id

  providers = {
    databricks = databricks.account
  }
}
