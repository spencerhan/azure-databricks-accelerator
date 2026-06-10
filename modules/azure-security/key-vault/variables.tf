variable "kv_name" {
  description = "The name of the Azure Key Vault."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the Key Vault."
  type        = string
}

variable "location" {
  description = "The Azure region where the Key Vault will be created."
  type        = string
}

variable "kv_sku_name" {
  description = "The SKU name of the Key Vault. Possible values are 'standard' and 'premium'."
  type        = string
  default     = "standard"
}

variable "tenant_id" {
  description = "The Azure Active Directory tenant ID that should be used for authenticating requests to the Key Vault."
  type        = string
}

variable "kv_soft_delete_retention_days" {
  description = "The number of days that items should be retained while soft deleted."
  type        = number
}

variable "kv_purge_protection_enabled" {
  description = "Is purge protection enabled for this Key Vault?"
  type        = bool
  default     = true
}

variable "network_acls" {
  description = "Network ACLs for the Key Vault."
  type = object({
    bypass                     = optional(string)
    default_action             = optional(string)
    ip_rules                   = optional(list(string))
    virtual_network_subnet_ids = optional(list(string))
  })
  default = null
}

variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
}

variable "purge_protection_enabled" {
  description = "Whether to enable purge protection on the Key Vault. When enabled, deleted Key Vaults cannot be purged for a retention period specified by kv_soft_delete_retention_days."
  type        = bool
  default     = true
}

variable "public_network_access_enabled" {
  description = "Whether to allow public network access to the Key Vault. If false, only private endpoints can access the Key Vault."
  type        = bool
  default     = true
}

variable "rbac_authorization_enabled" {
  type    = bool
  default = true
}

variable "kv_role_assignments" {
  description = "Map of role assignments to be applied at the key vault data plane scope. Each key is a unique name, value is an object with role_definition_name, principal_id, and optional description."
  type = map(object({
    principal_id         = string
    role_definition_name = string
    description          = optional(string)
  }))
  default = {}
}

variable "kv_access_assignments" {
  description = "Map of access policy assignments to be applied at the key vault data plane scope. Each key is a unique name, value is an object with principal_id, and optional key_permissions and secret_permissions."
  type = map(object({
    principal_id            = string
    secret_permissions      = optional(list(string))
    key_permissions         = optional(list(string))
    certificate_permissions = optional(list(string))
  }))
  default = {}
}

# variable "kv_secrets" {
#   description = "A secrets map objects"
#   type = map(object({
#     secret_name  = string
#     secret_value = string
#   }))
#   default = null
# }