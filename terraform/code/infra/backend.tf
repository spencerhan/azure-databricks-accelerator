terraform {
  # Local state by default. To use Azure remote state, pass:
  #   terraform init -backend-config=backend.hcl -reconfigure
  backend "local" {}
}
