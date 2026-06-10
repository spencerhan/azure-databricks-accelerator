variable "scope" {
  description = "The scope at which the role assignment applies. This can be a subscription, resource group, or specific resource."
  type        = string
}

variable "assignments" {
  description = "Map of role assignments. Each key is a unique name, value is an object with scope, role_definition_name, principal_id, and optional condition, condition_version, description."
  type = map(object({
    role_definition_name = string
    principal_id         = string
    description          = optional(string)
  }))
}