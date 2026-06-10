variable "nsg_rule_name" {
  description = "The name of the Network Security Rule."
  type        = string
}

variable "nsg_rule_priority" {
  description = "The priority of the rule. The value can be between 100 and 4096."
  type        = number
}

variable "nsg_rule_direction" {
  description = "The direction of the rule. Possible values are 'Inbound' and 'Outbound'."
  type        = string
}

variable "nsg_rule_access" {
  description = "The network traffic is allowed or denied. Possible values are 'Allow' and 'Deny'."
  type        = string
}

variable "protocol" {
  description = "Network protocol this rule applies to. Possible values are 'Tcp', 'Udp', 'Icmp', or '*'."
  type        = string
}

variable "source_port_ranges" {
  description = "List of source port ranges."
  type        = list(string)
}

variable "destination_port_ranges" {
  description = "List of destination port ranges."
  type        = list(string)
}

variable "source_address_prefix" {
  description = "The CIDR or source IP range."
  type        = string
}

variable "destination_address_prefix" {
  description = "The CIDR or destination IP range."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the network security rule."
  type        = string
}

variable "nsg_name" {
  description = "The name of the Network Security Group to which to attach the rule."
  type        = string
}