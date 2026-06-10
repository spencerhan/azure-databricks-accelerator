# =============================================================================
# Pattern 2 — Backend private connectivity only (Secure Cluster Connectivity)
#
# - VNet injection ENABLED (host + container subnets delegated to Databricks).
# - Workspace public network access REMAINS ENABLED (frontend stays public — users
#   reach the web UI / REST API over the internet).
# - Secure Cluster Connectivity: data-plane to control-plane traffic is forced
#   onto the private backend via the workspace `databricks_ui_api` private
#   endpoint and `NoAzureDatabricksRules` NSG mode.
# - Storage & Key Vault are accessed via private endpoints.
# - No NCC (serverless compute will use Databricks-managed public egress).
#
# Reference:
#   https://learn.microsoft.com/en-us/azure/databricks/security/network/classic/private-link
# =============================================================================

target_environment   = "test"
connectivity_pattern = "backend-private"
region               = "australiaeast"
region_shortname     = "aue"
name_prefix          = "dbxacc"

tenant_id = "REPLACE_WITH_TENANT_ID"

# Networking — tune to your address management policy.
vnet_address_space  = ["10.150.0.0/20"]
public_subnet_cidr  = "10.150.0.0/24"
private_subnet_cidr = "10.150.1.0/24"
pep_subnet_cidr     = "10.150.2.0/26"

# With private endpoints in place, you can lock down public network access on
# storage and key vault. Set to false if your operators don't need direct
# public access from the internet.
storage_public_network_access_enabled   = false
key_vault_public_network_access_enabled = false

tags = {
  Owner      = "platform-team"
  CostCentre = "0000"
}
