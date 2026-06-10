variable "private_service_connection" {
  description = "Configuration block for the private service connection. Should include required fields such as name, private_connection_resource_id, is_manual_connection, and subresource_names."
  type = object({
    name                           = string
    private_connection_resource_id = string
    is_manual_connection           = bool
    subresource_names              = optional(list(string))
    request_message                = optional(string)
  })

  validation {
    condition = (
      var.private_service_connection.request_message == null ||
      (
        var.private_service_connection.is_manual_connection == true &&
        length(var.private_service_connection.request_message) <= 128
      )
    )
    error_message = "request_message can only be set if is_manual_connection is true and must be at most 128 characters."
  }
  default = null
}
variable "pe_name" {
  description = "Name of the private endpoint."
  type        = string
}

variable "location" {
  description = "Azure region where the private endpoint will be created."
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group."
  type        = string
}

variable "subnet_id" {
  description = "ID of the subnet to which the private endpoint will be connected."
  type        = string
}

variable "tags" {
  description = "Tags to assign to the private endpoint."
  type        = map(string)
}

variable "private_dns_zone_group" {
  description = "Configuration block for the private DNS zone group. Should include required fields such as name and private_dns_zone_ids."
  type = object({
    name                 = string
    private_dns_zone_ids = list(string)
  })
  default = null
}
