# Shared inputs for the role-assignments root. The same file is reused across
# all three patterns — the only thing it does is wire workspace-level USER /
# ADMIN permissions on the Databricks workspace.

tenant_id             = "REPLACE_WITH_TENANT_ID"
databricks_account_id = "REPLACE_WITH_DATABRICKS_ACCOUNT_ID"

# Use either AAD object IDs (for security groups) or Databricks group display
# names. Leave both lists empty to skip workspace assignments entirely.

dbx_wks_admin_principals    = []
dbx_wks_user_principals     = []
dbx_wks_admin_display_names = [] # e.g. ["dbx-admins"]
dbx_wks_user_display_names  = [] # e.g. ["dbx-users"]
