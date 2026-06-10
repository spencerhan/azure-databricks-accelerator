variable "sa_key" {
  type = string
}

variable "sa_config" {
  type = object({
    st_name = string
    containers = map(object({
      container_name = string
      directories    = optional(list(string))
    }))
  })
}

variable "access_connector_id" {
  type = string
}

variable "volume_schema_name" {
  type    = string
  default = "volumes"
}

variable "workspace_id" {
  description = "workspace_id"
  type        = string
}

variable "create_default_namespace_setting" {
  description = "Whether to create a databricks_default_namespace_setting for this workspace."
  type        = bool
  default     = false
}

variable "default_namespace_value" {
  description = "The catalog name to set as the default namespace. Required when create_default_namespace_setting is true."
  type        = string
  default     = null
}