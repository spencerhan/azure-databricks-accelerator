variable "storage_account_id" {
  description = "The ID of the storage account to enable Defender for Storage."
  type        = string
}

variable "malware_scanning_on_upload_enabled" {
  description = "Enable malware scanning on upload for the storage account."
  type        = bool
  default     = true
}

variable "malware_scanning_cap_gb_per_month" {
  description = "Monthly cap in GB for malware scanning. Only applied if malware_scanning_on_upload_enabled is true."
  type        = number
  default     = 100
}

variable "sensitive_data_discovery_enabled" {
  description = "Enable sensitive data discovery for the storage account."
  type        = bool
  default     = true
}