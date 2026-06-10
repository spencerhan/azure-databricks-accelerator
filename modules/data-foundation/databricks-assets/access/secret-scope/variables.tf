
variable "secret_scope_name" {
  description = "The name of the Databricks secret scope."
  type        = string
}

variable "key_vault_id" {
  description = "The Azure Resource ID of the Key Vault to back the secret scope."
  type        = string
}

variable "key_vault_uri" {
  description = "The DNS name (URI) of the Azure Key Vault."
  type        = string
}