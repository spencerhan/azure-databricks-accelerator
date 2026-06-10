variable "instance_pool_name" {
  type        = string
  description = "Name of the Databricks instance pool"
}

variable "node_type_id" {
  type        = string
  description = "Node type ID for the Databricks instance pool"
}


variable "preloaded_spark_versions" {
  type        = list(string)
  description = "List of Spark versions to preload on the instance pool"
}

variable "custom_tags" {
  type        = map(string)
  description = "Custom tags to apply to the Databricks instance pool"
  default     = {}
}

variable "access_controls" {
  type = list(object({
    group_name       = string
    permission_level = string
  }))
  description = "List of access control entries to assign permissions on the Databricks instance pool"
  default     = []
}