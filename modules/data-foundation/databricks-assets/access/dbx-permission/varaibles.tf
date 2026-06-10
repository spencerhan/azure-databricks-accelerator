variable "instance_pool_id" {
  type        = string
  description = "ID of the Databricks instance pool to assign permissions to"
}

variable "access_controls" {
  type = list(object({
    group_name       = string
    permission_level = string
  }))
  description = "List of access control entries to assign permissions on the Databricks instance pool"
  default     = []

  validation {
    condition     = alltrue([for a in var.access_controls : contains(["CAN_ATTACH_TO", "NO_PERMISSION", "CAN_MANAGE"], a.permission_level)])
    error_message = "permission_level must be one of CAN_ATTACH_TO, NO_PERMISSION, CAN_MANAGE."
  }

}