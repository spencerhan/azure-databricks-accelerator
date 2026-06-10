provider "azurerm" {
  subscription_id = var.subscription_id
  features {}
}

# Account-level provider (needed for NCC and account-scoped operations).
# Authenticate via `databricks auth login` or the standard DATABRICKS_* env vars.
provider "databricks" {
  alias      = "account"
  host       = "https://accounts.azuredatabricks.net"
  account_id = var.databricks_account_id
}
