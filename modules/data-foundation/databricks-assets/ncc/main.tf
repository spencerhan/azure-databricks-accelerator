
terraform {
  required_providers {
    databricks = {
      source = "databricks/databricks"
    }
  }
}

resource "databricks_mws_network_connectivity_config" "ncc" {
  name   = var.ncc_name
  region = var.region
}


resource "databricks_mws_ncc_binding" "ncc_binding" {
  network_connectivity_config_id = databricks_mws_network_connectivity_config.ncc.network_connectivity_config_id
  workspace_id                   = var.workspace_id
}

resource "databricks_mws_ncc_private_endpoint_rule" "sa_blob" {
  network_connectivity_config_id = databricks_mws_network_connectivity_config.ncc.network_connectivity_config_id
  resource_id                    = var.storage_account_resource_id
  group_id                       = "blob"

}


resource "databricks_mws_ncc_private_endpoint_rule" "sa_dfs" {
  network_connectivity_config_id = databricks_mws_network_connectivity_config.ncc.network_connectivity_config_id
  resource_id                    = var.storage_account_resource_id
  group_id                       = "dfs"

}


resource "databricks_mws_ncc_private_endpoint_rule" "sa_kv" {
  network_connectivity_config_id = databricks_mws_network_connectivity_config.ncc.network_connectivity_config_id
  resource_id                    = var.key_vault_resource_id
  group_id                       = "vault"

}

