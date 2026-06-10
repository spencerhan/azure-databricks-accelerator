variable "tags" {
  type        = map(string)
  description = "Item tags to be applied to all resources"
}

variable "rg_name" {
  type        = string
  description = "The name of the resource group"
}

variable "rg_location" {
  type        = string
  description = "The location of the resource group"
}

variable "enable_lock" {
  type        = bool
  description = "Whether to enable a management lock on the resource group to prevent accidental deletion"
  default     = true
}

variable "role_assignments" {
  description = "Map of role assignments to be applied at the resource group scope. Each key is a unique name, value is an object with role_definition_name, principal_id, and optional description."
  type = map(object({
    role_definition_name = string
    principal_id         = string
    description          = optional(string)
  }))
  default = {}
}