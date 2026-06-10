variable "dbx_wks_permission_assignments" {
  description = "Map of role assignments. Each key is a unique name, value is an object with permission_name (ADMIN or USER) and principal_id."
  type = map(object({
    permission_name = string
    principal_id    = string
  }))

  validation {
    condition = alltrue([
      for assignment in values(var.dbx_wks_permission_assignments) :
      contains(["ADMIN", "USER"], assignment.permission_name)
    ])
    error_message = "permission_name must be either 'ADMIN' or 'USER'."
  }
}

variable "workspace_id" {
  type        = string
  description = "Azure Databricks Workspace ID where the permissions will be assigned"
}