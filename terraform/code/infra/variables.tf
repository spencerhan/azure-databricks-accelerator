variable "subscription_id" {
  type        = string
  description = "Azure subscription ID to deploy into. Can also be supplied via ARM_SUBSCRIPTION_ID."
  default     = null
}

variable "tenant_id" {
  type        = string
  description = "Azure AD tenant ID."
}

variable "target_environment" {
  type        = string
  description = "Target environment short name (e.g. dev, test, prod)."
}

variable "connectivity_pattern" {
  type        = string
  description = <<EOT
Databricks connectivity pattern:
- "public"           : barebone, no VNet injection, public frontend, no PEs
- "backend-private"  : VNet injection + Secure Cluster Connectivity (backend PE), public frontend
- "full-private"     : VNet injection + backend AND browser-auth PEs, frontend forced through private link
EOT

  validation {
    condition     = contains(["public", "backend-private", "full-private"], var.connectivity_pattern)
    error_message = "connectivity_pattern must be one of: public, backend-private, full-private."
  }
}

variable "region" {
  type        = string
  description = "Azure region."
  default     = "australiaeast"
}

variable "region_shortname" {
  type        = string
  description = "Short region code used in resource names."
  default     = "aue"
}

variable "name_prefix" {
  type        = string
  description = "Prefix used for all resource names (lowercase, short)."
  default     = "dbxacc"
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to all resources."
  default     = {}
}

# Networking -------------------------------------------------------------------
variable "vnet_address_space" {
  type        = list(string)
  default     = ["10.150.0.0/20"]
  description = "VNet address space (only used when VNet injection is required)."
}

variable "public_subnet_cidr" {
  type        = string
  default     = "10.150.0.0/24"
  description = "CIDR for the Databricks host (public) subnet."
}

variable "private_subnet_cidr" {
  type        = string
  default     = "10.150.1.0/24"
  description = "CIDR for the Databricks container (private) subnet."
}

variable "pep_subnet_cidr" {
  type        = string
  default     = "10.150.2.0/26"
  description = "CIDR for the private endpoints subnet."
}

# Storage / Key Vault ----------------------------------------------------------
variable "create_storage_private_endpoints" {
  type        = bool
  default     = null
  description = "Create blob/dfs private endpoints. Defaults: false for 'public', true for the private patterns."
}

variable "create_key_vault_private_endpoint" {
  type        = bool
  default     = null
  description = "Create Key Vault private endpoint. Defaults follow storage."
}

variable "storage_public_network_access_enabled" {
  type        = bool
  default     = true
  description = "Whether the storage account allows public network access."
}

variable "key_vault_public_network_access_enabled" {
  type        = bool
  default     = true
  description = "Whether the Key Vault allows public network access."
}

# Databricks -------------------------------------------------------------------
variable "dbx_workspace_sku" {
  type        = string
  default     = "premium"
  description = "Databricks SKU. Use 'premium' for any private-link or NCC scenario."
}

variable "principal_ids_dbx_contributors" {
  type        = list(string)
  description = "Azure AD object IDs to grant Contributor on the Databricks workspace."
  default     = []
}

variable "principal_ids_dbx_readers" {
  type        = list(string)
  description = "Azure AD object IDs to grant Reader on the Databricks workspace."
  default     = []
}
