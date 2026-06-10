variable "storage_account_resource_id" {
  type        = string
  description = "Resource ID of the storage account to connect to Databricks Unity Catalog. This is required to set up external locations in the catalog that point to the storage account, and to grant the necessary permissions on the storage account for Unity Catalog to access it."
}

variable "workspace_id" {
  type        = string
  description = "The workspace ID of the Databricks workspace to bind the network connectivity configuration to. This is required to establish the connection between the network connectivity configuration and the Databricks workspace, allowing the workspace to use the private endpoints defined in the network connectivity configuration for secure communication with Azure services."
}

variable "key_vault_resource_id" {
  type        = string
  description = "Resource ID of the Azure Key Vault to connect to Databricks Unity Catalog. This is required to set up private endpoint rules for the Key Vault in the network connectivity configuration, allowing secure access to secrets stored in the Key Vault from Databricks."
}

variable "ncc_name" {
  type        = string
  description = "Name of the Databricks Network Connectivity Configuration (NCC) to create. This is used to identify the NCC resource in Azure and within Databricks, and is required for creating the NCC and binding it to the Databricks workspace."
}

variable "region" {
  type        = string
  description = "Azure region where the Databricks Network Connectivity Configuration (NCC) will be created. This should be the same region as the Databricks workspace to ensure optimal performance and connectivity between the NCC and the workspace."
}

