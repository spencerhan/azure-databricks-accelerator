terraform {
  required_providers {
    databricks = {
      source = "databricks/databricks"
    }
  }
}

locals {
  st_name = var.sa_config.st_name

  containers = {
    for k, c in var.sa_config.containers :
    k => merge(c, { directories = c.directories != null ? c.directories : [] })
  }

  with_dirs = { for k, c in local.containers : k => c if length(c.directories) > 0 }
  no_dirs   = { for k, c in local.containers : k => c if length(c.directories) == 0 }

  container_url = {
    for k, c in local.containers :
    k => format("abfss://%s@%s.dfs.core.windows.net/", c.container_name, local.st_name)
  }

  safe = {
    for k, c in local.containers :
    k => replace(replace(replace(lower(c.container_name), "-", "_"), " ", "_"), ".", "_")
  }
}

resource "databricks_storage_credential" "storage_credential" {
  name    = "${local.st_name}-credential"
  comment = "Managed by Terraform"

  azure_managed_identity {
    access_connector_id = var.access_connector_id
  }
}

resource "databricks_external_location" "storage_external_location" {
  # create for ALL containers (or only with_dirs if you want)
  for_each = local.containers

  name            = local.safe[each.key]
  url             = local.container_url[each.key]
  credential_name = databricks_storage_credential.storage_credential.name
  depends_on      = [databricks_storage_credential.storage_credential]
}

# resource "databricks_catalog" "dir_container_catalog" {
#   for_each       = local.with_dirs
#   name           = local.safe[each.key]
#   storage_root   = local.container_url[each.key]
#   isolation_mode = "ISOLATED"
#   depends_on     = [databricks_external_location.storage_external_location]
# }

# resource "databricks_workspace_binding" "catalog_binding_with_dirs" {
#   for_each       = databricks_catalog.dir_container_catalog
#   securable_name = each.value.name
#   workspace_id   = var.workspace_id
#   binding_type   = "BINDING_TYPE_READ_WRITE"
# }

locals {
  schemas_flat = {
    for obj in flatten([
      for ck, c in local.with_dirs : [
        for d in c.directories : {
          key         = "${ck}.${d}"
          container_k = ck
          dir_name    = d
          schema_name = replace(replace(replace(lower(d), "-", "_"), " ", "_"), ".", "_")
        }
      ]
    ]) : obj.key => obj
  }
}

# resource "databricks_schema" "dir_schema" {
#   for_each     = local.schemas_flat
#   catalog_name = databricks_catalog.dir_container_catalog[each.value.container_k].name
#   name         = each.value.schema_name
#   storage_root = format("%s%s/", local.container_url[each.value.container_k], each.value.dir_name)
# }


# For containers without directories, create a separate catalog and schema for each, then create a volume in that catalog.
# resource "databricks_catalog" "no_dir_container_catalog" {
#   for_each       = local.no_dirs
#   name           = local.safe[each.key]
#   storage_root   = local.container_url[each.key]
#   isolation_mode = "ISOLATED"
#   depends_on     = [databricks_external_location.storage_external_location]
# }


# resource "databricks_workspace_binding" "catalog_binding_no_dirs" {
#   for_each       = databricks_catalog.no_dir_container_catalog
#   securable_name = each.value.name
#   workspace_id   = var.workspace_id
#   binding_type   = "BINDING_TYPE_READ_WRITE"
# }

# resource "databricks_schema" "no_dir_volume_schema" {
#   for_each     = local.no_dirs
#   catalog_name = databricks_catalog.no_dir_container_catalog[each.key].name
#   name         = var.volume_schema_name
# }


# resource "databricks_volume" "container_volume" {
#   for_each = local.no_dirs
#
#   name         = local.safe[each.key]
#   catalog_name = databricks_catalog.no_dir_container_catalog[each.key].name
#   schema_name  = databricks_schema.no_dir_volume_schema[each.key].name
#
#   volume_type = "EXTERNAL"
#   # Place the volume in a subdirectory to avoid overlap with catalog storage_root
#   storage_location = format("%svolumes/%s/", local.container_url[each.key], local.safe[each.key])
#   depends_on       = [databricks_catalog.no_dir_container_catalog]
# }

# resource "databricks_default_namespace_setting" "default_catalog" {
#   count = var.create_default_namespace_setting ? 1 : 0
#
#   namespace {
#     value = var.default_namespace_value
#   }
#
#   depends_on = [
#     databricks_catalog.dir_container_catalog,
#     databricks_catalog.no_dir_container_catalog
#   ]
# }




