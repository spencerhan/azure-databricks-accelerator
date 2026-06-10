variable "key_vault_id" {
  description = "The ID of the Azure Key Vault."
  type        = string
}

variable "tenant_id" {
  description = "The Azure Active Directory tenant ID."
  type        = string
}

variable "kv_access_assignments" {
  description = "A map of access assignments, where each value contains a principal_id."
  type = map(object({
    principal_id            = string
    key_permissions         = optional(list(string))
    secret_permissions      = optional(list(string))
    certificate_permissions = optional(list(string))
  }))
}