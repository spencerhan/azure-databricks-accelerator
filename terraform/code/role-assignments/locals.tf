locals {
  workspace_id = data.terraform_remote_state.infra.outputs.dbx_workspace_id

  user_assignments_from_ids = {
    for k, g in data.databricks_group.users_by_id :
    g.id => { principal_id = g.id, permission_name = "USER" }
  }

  admin_assignments_from_ids = {
    for k, g in data.databricks_group.admins_by_id :
    g.id => { principal_id = g.id, permission_name = "ADMIN" }
  }

  user_assignments_from_names = {
    for k, g in data.databricks_group.users_by_name :
    g.id => { principal_id = g.id, permission_name = "USER" }
  }

  admin_assignments_from_names = {
    for k, g in data.databricks_group.admins_by_name :
    g.id => { principal_id = g.id, permission_name = "ADMIN" }
  }

  # Merge order ensures ADMIN overrides USER if the same group appears in both.
  dbx_wks_permission_assignments = merge(
    local.user_assignments_from_ids,
    local.user_assignments_from_names,
    local.admin_assignments_from_ids,
    local.admin_assignments_from_names,
  )
}
