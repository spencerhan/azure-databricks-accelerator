output "ncc_deployed" {
  value = local.needs_ncc
}

# Forward selected infra outputs so role-assignments can read databricks state
# without re-reading infra remote state.
output "dbx_workspace_id" {
  value = local.workspace_id
}

output "dbx_workspace_url" {
  value = data.terraform_remote_state.infra.outputs.dbx_workspace_url
}
