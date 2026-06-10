output "storage_credential_name" {
  description = "Storage credential created for this environment/storage account"
  value       = databricks_storage_credential.storage_credential.name
}

output "external_locations" {
  description = "External locations created for all containers"
  value = {
    for k, v in databricks_external_location.storage_external_location :
    k => {
      name = v.name
      url  = v.url
    }
  }
}

# output "catalogs" {
#   description = "Unity Catalog catalogs created (keyed by container key)"
#   value = {
#     for k, v in databricks_catalog.dir_container_catalog :
#     k => v.name
#   }
# }

# output "schemas" {
#   description = "Schemas created per catalog (keyed by container.directory)"
#   value = merge(
#     databricks_schema.dir_schema,
#     length(keys(databricks_schema.no_dir_volume_schema)) > 0 ? {
#       "volumes" = databricks_schema.no_dir_volume_schema
#     } : {}
#   )
#   # If you want the same structure as before:
#   # value = {
#   #   for k, v in merge(
#   #     databricks_schema.dir_schema,
#   #     length(databricks_schema.volume_schema) > 0 ? { "volumes" = databricks_schema.volume_schema[0] } : {}
#   #   ) :
#   #   k => {
#   #     catalog = v.catalog_name
#   #     schema  = v.name
#   #     fqdn    = "${v.catalog_name}.${v.name}"
#   #   }
#   # }
# }


# output "dir_schemas" {
#   description = "Schema that hosts volumes"
#   value       = { for k, v in databricks_schema.dir_schema : k => v.name }
# }


# output "volumes_schema" {
#   description = "Schema that hosts volumes"
#   value       = length(keys(databricks_schema.no_dir_volume_schema)) > 0 ? [for k in keys(databricks_schema.no_dir_volume_schema) : databricks_schema.no_dir_volume_schema[k].name] : null
# }

# output "volumes" {
#   description = "Volumes created for containers without directories"
#   value = {
#     for k, v in databricks_volume.container_volume :
#     k => {
#       catalog          = v.catalog_name
#       schema           = v.schema_name
#       volume           = v.name
#       fqdn             = "${v.catalog_name}.${v.schema_name}.${v.name}"
#       storage_location = v.storage_location
#     }
#   }
# }

# output "catalog_names" {
#   value = values(databricks_catalog.dir_container_catalog)[*].name
# }