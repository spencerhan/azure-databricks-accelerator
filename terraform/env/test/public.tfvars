# =============================================================================
# Pattern 1 — Public (barebone) Azure Databricks
#
# - No VNet injection (Databricks uses its own managed network).
# - Workspace public network access ENABLED.
# - No private endpoints, no private DNS zones, no NCC.
# - Suitable for non-sensitive workloads, demos, learning environments.
#
# Cost-wise this is the cheapest deployment.
# =============================================================================

target_environment   = "test"
connectivity_pattern = "public"
region               = "australiaeast"
region_shortname     = "aue"
name_prefix          = "dbxacc"

# Required — set to your Azure AD tenant ID.
tenant_id = "REPLACE_WITH_TENANT_ID"

# Optional — explicit subscription ID. If null, the value is read from ARM_SUBSCRIPTION_ID.
# subscription_id = "00000000-0000-0000-0000-000000000000"

# Defaults are fine for the public pattern (PEs/DNS zones disabled).
storage_public_network_access_enabled   = true
key_vault_public_network_access_enabled = true

tags = {
  Owner      = "platform-team"
  CostCentre = "0000"
}
