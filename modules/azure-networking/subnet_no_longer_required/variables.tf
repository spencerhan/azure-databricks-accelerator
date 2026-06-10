
variable "vnet_name" {
  description = "Existing VNet ID"
  type        = string
}


variable "snet_name" {
  description = "The name of the subnet."
  type        = string
}

variable "address_prefixes" {
  description = "The list of address prefixes for the subnet."
  type        = list(string)
}

variable "rg_name" {
  description = "The name of the resource group containing the virtual network."
  type        = string
}

variable "virtual_network_name" {
  description = "The name of the virtual network to which the subnet belongs."
  type        = string
}

variable "delegation" {
  description = "Optional delegation block for the subnet. Only one delegation per subnet is allowed."
  type = object({
    name = string
    service_delegation = object({
      name    = string
      actions = optional(list(string))
    })
  })
  default = null
}


variable "default_outbound_access_enabled" {
  description = "Whether to enable default outbound access for the subnet."
  type        = bool
  default     = false
}


variable "private_endpoint_network_policies" {
  description = "The state of private endpoint network policies for the subnet."
  type        = string
  default     = "Disabled"
  validation {
    condition     = contains(["Disabled", "Enabled", "NetworkSecurityGroupEnabled", "RouteTableEnabled"], var.private_endpoint_network_policies)
    error_message = "private_endpoint_network_policies must be one of: Disabled, Enabled, NetworkSecurityGroupEnabled, RouteTableEnabled."
  }
}


variable "service_endpoints" {
  description = "A list of Service endpoints to associate with the subnet"
  type        = list(string)
  default     = []
  validation {
    condition = alltrue([
      for v in var.service_endpoints : contains([
        "Microsoft.AzureActiveDirectory",
        "Microsoft.AzureCosmosDB",
        "Microsoft.ContainerRegistry",
        "Microsoft.EventHub",
        "Microsoft.KeyVault",
        "Microsoft.ServiceBus",
        "Microsoft.Sql",
        "Microsoft.Storage",
        "Microsoft.Storage.Global",
        "Microsoft.Web"
      ], v)
    ])
    error_message = "Each service_endpoints value must be one of: Microsoft.AzureActiveDirectory, Microsoft.AzureCosmosDB, Microsoft.ContainerRegistry, Microsoft.EventHub, Microsoft.KeyVault, Microsoft.ServiceBus, Microsoft.Sql, Microsoft.Storage, Microsoft.Storage.Global, Microsoft.Web."
  }
}