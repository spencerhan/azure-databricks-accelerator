variable "dbx_access_connector_name" {
  description = "Name of the Databricks Access Connector."
  type        = string
}

variable "dbx_workspace_name" {
  description = "Name of the Databricks workspace."
  type        = string
}


variable "location" {
  description = "Azure region."
  type        = string
}

variable "resource_group_name" {
  description = "Existing Resource Group to deploy the workspace into."
  type        = string
}

variable "sku" {
  description = "Databricks SKU. Common values: 'standard', 'premium'."
  type        = string
  default     = "premium"
}

variable "dbx_mrg_name" {
  description = "Optional managed resource group name. If null, Azure will generate one."
  type        = string

}

variable "public_network_access_enabled" {
  description = "Whether public network access is enabled for the workspace."
  type        = bool
}

variable "network_security_group_rules_required" {
  description = "Whether the data plane (clusters) to control plane communication happen over private link endpoint only or publicly"
  type        = string
  default     = "NoAzureServiceRules"

  validation {
    condition = (
      (
        var.public_network_access_enabled == true && contains(["AllRules", "NoAzureDatabricksRules", "NoAzureServiceRules"], var.network_security_group_rules_required)
      ) ||
      (
        var.public_network_access_enabled == false && var.network_security_group_rules_required != null && contains(["AllRules", "NoAzureDatabricksRules", "NoAzureServiceRules"], var.network_security_group_rules_required)
      )
    )
    error_message = "network_security_group_rules_required is required and must be one of: AllRules, NoAzureDatabricksRules, NoAzureServiceRules when public_network_access_enabled is set to false."
  }
}


variable "dbx_custom_parameters" {
  description = "Optional custom parameters"
  type = object({
    vnet_id                           = string
    public_subnet_name                = string
    private_subnet_name               = string
    public_subnet_nsg_association_id  = string
    private_subnet_nsg_association_id = string
    dbx_storage_account_name          = string
    no_public_ip                      = bool
  })
  default = null
}

variable "tags" {
  description = "Tags to apply to the workspace."
  type        = map(string)
  default     = {}
}

variable "role_assignments" {
  type = map(object({
    principal_id         = string
    role_definition_name = string
    description          = optional(string)
  }))
  description = "Map of role assignments to create for the Databricks workspace. Key is a unique identifier for the assignment, value is an object with properties like principal_id, role_definition_name, etc."
  default     = {}
}