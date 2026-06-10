variable "groups" {
  description = "A map of groups to create in Databricks."
  type = map(object({
    display_name = string
    object_id    = string
  }))
}
