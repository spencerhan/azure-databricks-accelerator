variable "subscription_id" {
  type    = string
  default = null
}

variable "tenant_id" {
  type        = string
  description = "Azure AD tenant ID."
}

variable "databricks_account_id" {
  type        = string
  description = "Databricks account ID (GUID)."
  sensitive   = true
}

variable "infra_state_path" {
  type        = string
  description = "Filesystem path to the infra state."
  default     = "../infra/terraform.tfstate"
}

variable "dbx_wks_admin_principals" {
  type        = list(string)
  description = "Azure AD group object IDs to grant ADMIN on the workspace."
  default     = []
}

variable "dbx_wks_user_principals" {
  type        = list(string)
  description = "Azure AD group object IDs to grant USER on the workspace."
  default     = []
}

variable "dbx_wks_admin_display_names" {
  type        = list(string)
  description = "Databricks group display names to grant ADMIN on the workspace."
  default     = []
}

variable "dbx_wks_user_display_names" {
  type        = list(string)
  description = "Databricks group display names to grant USER on the workspace."
  default     = []
}
