variable "location" {
  description = "Azure region for resources"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "nat_idle_timeout_in_minutes" {
  description = "Idle timeout for NAT Gateway in minutes"
  type        = number
  default     = 4
}

variable "dbx_public_subnet_id" {
  description = "Resource ID of the Databricks public subnet"
  type        = string
}

variable "dbx_private_subnet_id" {
  description = "Resource ID of the Databricks private subnet"
  type        = string
}

variable "pip_name" {
  description = "Name for the NAT Gateway Public IP"
  type        = string
}

variable "nat_gateway_name" {
  description = "Name for the NAT Gateway"
  type        = string
}

variable "tags" {
  type        = map(string)
  description = "Item tags to be applied to all resources"
}