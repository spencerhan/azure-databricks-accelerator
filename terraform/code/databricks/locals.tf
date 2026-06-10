locals {
  base               = "${var.name_prefix}-${var.target_environment}-${var.region_shortname}"
  needs_ncc          = try(data.terraform_remote_state.infra.outputs.needs_ncc, false)
  workspace_id       = data.terraform_remote_state.infra.outputs.dbx_workspace_id
  storage_account_id = data.terraform_remote_state.infra.outputs.storage_account_id
  key_vault_id       = data.terraform_remote_state.infra.outputs.key_vault_id
  ncc_name           = "${local.base}-dbw-ncc"
}
