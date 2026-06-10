target_environment = "dev"
region             = "australiaeast"
region_shortname   = "aue"
name_prefix        = "dbxacc"

# Not used for the "public" pattern (no NCC is created). A placeholder keeps
# the provider config happy. Set to your real Databricks account ID if you
# plan to expand this root to manage account-scope resources.
databricks_account_id = "00000000-0000-0000-0000-000000000000"
