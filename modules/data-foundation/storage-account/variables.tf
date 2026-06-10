variable "tags" {
  description = "Tags to apply to the storage account."
  type        = map(string)
}
variable "st_name" {
  description = "Globally-unique storage account name (3-24 lower-case letters and numbers)."
  type        = string
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name."
}

variable "location" {
  type        = string
  description = "Region."
}

variable "account_tier" {
  description = "The performance tier of the storage account (Standard or Premium)."
  type        = string
  default     = "Standard"
}


variable "dbx_uc_type" {
  description = "Type of Unity Catalog external storage (blob_uc_catalog or adls_uc_catalog)."
  type        = string
  default     = "blob_uc_catalog"
  validation {
    condition     = contains(["blob_uc_catalog", "adls_uc_catalog"], var.dbx_uc_type)
    error_message = "dbx_uc_type must be either 'blob_uc_catalog' or 'adls_uc_catalog'."
  }
}

variable "account_replication_type" {
  description = "The replication type for the storage account (LRS, GRS, ZRS, etc.)."
  type        = string
  default     = "ZRS" # Consider ZRS/GRS for higher resiliency
  validation {
    condition     = contains(["LRS", "ZRS", "GRS", "GZRS", "RAGRS", "RAGZRS"], var.account_replication_type)
    error_message = "replication_type must be one of LRS, ZRS, GRS, GZRS, RAGRS, RAGZRS."
  }

}

variable "account_kind" {
  description = "The kind of storage account (Storage, StorageV2, BlobStorage, etc.)."
  type        = string
  default     = "StorageV2"
  validation {
    condition     = contains(["Storage", "StorageV2", "BlobStorage", "FileStorage", "BlockBlobStorage"], var.account_kind)
    error_message = "account_kind must be one of Storage, StorageV2, BlobStorage, FileStorage, BlockBlobStorage."
  }
}

variable "access_tier" {
  description = "The access tier for BlobStorage (Hot or Cool)."
  type        = string
  default     = "Hot"
}

variable "public_network_access_enabled" {
  description = "Whether to allow public network access to the storage account."
  type        = bool
  default     = true

}

variable "blob_versioning_enabled" {
  description = "Enable versioning for blobs in the storage account."
  type        = bool
  default     = true
}

variable "blob_delete_retention_days" {
  type    = number
  default = 14
}
variable "container_delete_retention_days" {
  type    = number
  default = 14
}


variable "uc_catalog_filesystems" {
  description = "List of filesystems to create (only applicable if is_hns_enabled is true)."
  type = list(object({
    name = string
  }))
  default = []
}

variable "uc_catalog_blobs" {
  description = "List of Unity Catalog blobs to create (only applicable if is_hns_enabled is false)."
  type = list(object({
    name = string
  }))
  default = []
}
# Network rules
variable "network_rules" {
  description = "Firewall rules for the storage account."
  type = object({
    default_action             = string       # Allow | Deny
    bypass                     = list(string) # ["AzureServices","Logging","Metrics","None"]
    ip_rules                   = list(string) # ["100.0.0.1"]
    virtual_network_subnet_ids = list(string)
  })
  default = null
  validation {
    condition = (
      var.network_rules == null ||
      contains(["Allow", "Deny"], var.network_rules.default_action)
    )
    error_message = "default_action must be either 'Allow' or 'Deny'."
  }
}


variable "is_hns_enabled" {
  description = "Enable hierarchical namespace (ADLS Gen2). If true -> ADLS Gen2; if false -> regular StorageV2."
  type        = bool
  default     = false
}


variable "containers" {
  description = "Map of containers keyed by container name."
  type = map(object({
    access_type    = string
    container_name = string
    enable_lock    = bool
    directories    = optional(list(string)) # Only applicable if is_hns_enabled is true
  }))
  default = {}
  validation {
    condition = length([
      for c in values(var.containers) :
      c if !contains(["blob", "container", "private"], c.access_type)
    ]) == 0
    error_message = "access_type must be one of 'private', 'blob', or 'container'."
  }
}

variable "role_assignments" {
  type = map(object({
    principal_id         = string
    role_definition_name = string
    description          = optional(string)
  }))
  description = "Map of role assignments to create for the storage accounts. Key is a unique identifier for the assignment, value is an object with properties like principal_id, role_definition_name, etc."
  default     = {}
}

variable "default_to_oauth_authentication" {
  description = "Whether to default to OAuth authentication for the storage account."
  type        = bool
}

# # Lifecycle policy (simple opinionated defaults)
# variable "lifecycle" {
#   description = "Lifecycle management rules for blobs."
#   type = object({
#     enabled                        = bool
#     cool_after_days                = number
#     archive_after_days             = number
#     delete_after_days              = number
#     delete_previous_versions_after = number
#   })
#   default = {
#     enabled                        = true
#     cool_after_days                = 30
#     archive_after_days             = 0    # 0 = disabled
#     delete_after_days              = 365
#     delete_previous_versions_after = 90
#   }
# }

