variable "subscription_id" {
  type    = string
  default = null
}

variable "databricks_account_id" {
  type        = string
  description = "Databricks account ID (GUID). Required only when the deployed pattern needs an NCC."
  default     = null
  sensitive   = true
}

variable "target_environment" {
  type        = string
  description = "Target environment short name (must match the value used in the infra root)."
}

variable "region" {
  type        = string
  description = "Azure region. Must match the infra deployment region."
  default     = "australiaeast"
}

variable "name_prefix" {
  type    = string
  default = "dbxacc"
}

variable "region_shortname" {
  type    = string
  default = "aue"
}

# Remote state location (matches infra backend if remote is configured).
# Defaults are filesystem paths that work with the bundled Makefile when using local state.
variable "infra_state_path" {
  type        = string
  description = "Filesystem path to the infra terraform.tfstate when using local backends."
  default     = "../infra/terraform.tfstate"
}
