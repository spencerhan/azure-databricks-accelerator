variable "location" {
  description = "Azure region."
  type        = string
}

variable "resource_group_name" {
  description = "Existing resource group name where the VNet and subnets are created."
  type        = string
}

variable "vnet_name" {
  description = "Name of the virtual network."
  type        = string
}

variable "address_space" {
  description = "Address space of the VNet."
  type        = list(string)
  default     = ["10.150.0.0/20"]
}

variable "nsg_name" {
  description = "Name of the NSG attached to the Databricks public/private subnets."
  type        = string
}

variable "public_subnet_name" {
  description = "Name of the Databricks public (host) subnet."
  type        = string
}

variable "public_subnet_cidr" {
  description = "CIDR of the Databricks public (host) subnet."
  type        = string
  default     = "10.150.0.0/24"
}

variable "private_subnet_name" {
  description = "Name of the Databricks private (container) subnet."
  type        = string
}

variable "private_subnet_cidr" {
  description = "CIDR of the Databricks private (container) subnet."
  type        = string
  default     = "10.150.1.0/24"
}

variable "pep_subnet_name" {
  description = "Name of the subnet used for private endpoints."
  type        = string
}

variable "pep_subnet_cidr" {
  description = "CIDR of the private endpoints subnet."
  type        = string
  default     = "10.150.2.0/26"
}

variable "tags" {
  description = "Tags applied to networking resources."
  type        = map(string)
  default     = {}
}
