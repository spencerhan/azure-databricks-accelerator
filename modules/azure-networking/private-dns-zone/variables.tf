variable "dns_zone_name" {
  description = "Name of the private DNS zone to create."
  type        = string

}

variable "rg_name" {
  description = "Name of the resource group where the private DNS zone will be created."
  type        = string
}

variable "vnet_id" {
  description = "ID of the virtual network to link with the private DNS zone."
  type        = string
}

variable "tags" {
  description = "Tags to assign to the private DNS zone."
  type        = map(string)
}