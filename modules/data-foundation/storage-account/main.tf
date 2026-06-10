resource "azurerm_storage_account" "st" {
  name                            = var.st_name
  resource_group_name             = var.resource_group_name
  location                        = var.location
  account_tier                    = var.account_tier
  account_replication_type        = var.account_replication_type
  account_kind                    = var.account_kind
  access_tier                     = var.account_kind == "BlockBlobStorage" ? null : var.access_tier
  is_hns_enabled                  = var.is_hns_enabled
  public_network_access_enabled   = var.public_network_access_enabled
  default_to_oauth_authentication = var.default_to_oauth_authentication
  min_tls_version                 = "TLS1_2"
  blob_properties {
    versioning_enabled = var.account_kind == "BlockBlobStorage" ? null : var.blob_versioning_enabled

    delete_retention_policy {
      days = var.blob_delete_retention_days
    }

    container_delete_retention_policy {
      days = var.container_delete_retention_days
    }
  }

  tags = var.tags

  timeouts {
    create = "20m"
    update = "20m"
    delete = "20m"
  }

}


resource "azurerm_storage_container" "st_container" {
  for_each = {
    for c in var.containers :
    c.container_name => c
    if c.directories == null || length(c.directories) == 0
  }
  name                  = each.value.container_name
  storage_account_id    = azurerm_storage_account.st.id
  container_access_type = each.value.access_type
}

resource "azurerm_storage_data_lake_gen2_filesystem" "uc_filesystem" {
  for_each = {
    for c in var.containers :
    c.container_name => c
    if c.directories != null && length(c.directories) > 0
  }
  name               = each.value.container_name
  storage_account_id = azurerm_storage_account.st.id

}

locals {
  adls_directories_flat = flatten([
    for container_name, c in var.containers :
    c.directories != null && length(c.directories) > 0 ? [
      for dir in c.directories : {
        filesystem_name = c.container_name
        directory       = trim(dir, "/")
      }
    ] : []
  ])

}

resource "azurerm_storage_data_lake_gen2_path" "uc_directory" {
  for_each = {
    for pair in local.adls_directories_flat :
    "${pair.filesystem_name}-${pair.directory}" => pair
  }
  filesystem_name    = each.value.filesystem_name
  path               = each.value.directory
  resource           = "directory"
  storage_account_id = azurerm_storage_account.st.id

  depends_on = [
    azurerm_storage_data_lake_gen2_filesystem.uc_filesystem
  ]
}


resource "azurerm_storage_account_network_rules" "st_network_rules" {
  count              = var.network_rules != null ? 1 : 0
  storage_account_id = azurerm_storage_account.st.id

  default_action             = var.network_rules.default_action
  bypass                     = try(var.network_rules.bypass, [])
  ip_rules                   = try(var.network_rules.ip_rules, [])
  virtual_network_subnet_ids = try(var.network_rules.virtual_network_subnet_ids, [])
}

module "role_assignment" {
  source      = "../../azure-governance/role-assignment"
  scope       = azurerm_storage_account.st.id
  assignments = var.role_assignments != null ? var.role_assignments : {}
}



# Apply CanNotDeleteLock, later can have more types of lock

module "resource_lock" {
  source = "../../azure-governance/resource-lock"
  for_each = {
    for key, container in var.containers : key => container
    if container.enable_lock == true
  }
  resource_id   = azurerm_storage_container.st_container[each.key].id
  resource_name = azurerm_storage_container.st_container[each.key].name
  lock_level    = "CanNotDelete"
  lock_notes    = "Prevent accidental deletion of the container"
}

# Lifecycle management policy (simple single rule)
# resource "azurerm_storage_management_policy" "st_mgmt_policy" {
#   count              = var.lifecycle.enabled ? 1 : 0
#   storage_account_id = azurerm_storage_account.st.id

#   rule {
#     name    = "base-lifecycle"
#     enabled = true

#     filters {
#       blob_types = ["blockBlob"]
#       prefix_match = []
#     }

#     actions {
#       base_blob {
#         tier_to_cool_after_days_since_modification_greater_than    = var.lifecycle.cool_after_days
#         tier_to_archive_after_days_since_modification_greater_than = var.lifecycle.archive_after_days > 0 ? var.lifecycle.archive_after_days : null
#         delete_after_days_since_modification_greater_than          = var.lifecycle.delete_after_days
#       }
#       snapshot  {
#         delete_after_days_since_creation_greater_than = var.lifecycle.delete_previous_versions_after
#       }
#     }
#   }
# }

# Diagnostics to Log Analytics
# module "st_diagnotics" {
#   source = "../../modules/azure-observability/diagnostic-setting"
# }
