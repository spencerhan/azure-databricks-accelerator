data "terraform_remote_state" "infra" {
  backend = "local"
  config = {
    path = var.infra_state_path
  }
}

data "azuread_group" "users" {
  for_each         = toset(var.dbx_wks_user_principals)
  object_id        = each.value
  security_enabled = true
}

data "azuread_group" "admins" {
  for_each         = toset(var.dbx_wks_admin_principals)
  object_id        = each.value
  security_enabled = true
}

data "databricks_group" "users_by_id" {
  for_each     = data.azuread_group.users
  display_name = each.value.display_name
  external_id  = each.value.object_id
  provider     = databricks.account
}

data "databricks_group" "admins_by_id" {
  for_each     = data.azuread_group.admins
  display_name = each.value.display_name
  external_id  = each.value.object_id
  provider     = databricks.account
}

data "databricks_group" "users_by_name" {
  for_each     = toset(var.dbx_wks_user_display_names)
  display_name = each.value
  provider     = databricks.account
}

data "databricks_group" "admins_by_name" {
  for_each     = toset(var.dbx_wks_admin_display_names)
  display_name = each.value
  provider     = databricks.account
}
