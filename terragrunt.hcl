locals {
  default_yaml_path = find_in_parent_folders("empty.yaml")

  org         = yamldecode(file(find_in_parent_folders("org.yaml",         local.default_yaml_path)))
  account     = yamldecode(file(find_in_parent_folders("account.yaml",     local.default_yaml_path)))
  region      = yamldecode(file(find_in_parent_folders("region.yaml",      local.default_yaml_path)))
  environment = yamldecode(file(find_in_parent_folders("env.yaml",         local.default_yaml_path)))
}

# ── AzureRM Provider ──────────────────────────────────────────────────────────
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.100"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "${local.account.azure_subscription_id}"
  tenant_id       = "${local.account.azure_tenant_id}"
}
EOF
}

# ── Azure Blob Backend (replaces your S3 backend) ────────────────────────────
# IMPORTANT: You must create this storage account manually once before running
# terragrunt. Run the bootstrap commands below.
remote_state {
  backend = "azurerm"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    resource_group_name  = "shalotrack-tfstate-rg"
    storage_account_name = "shalotfstate${local.environment.environment}"
    container_name       = "tfstate"
    key                  = "${path_relative_to_include()}/terraform.tfstate"
  }
}

# ── Merge all YAML variables into inputs ─────────────────────────────────────
inputs = merge(
  local.org,
  local.account,
  local.region,
  local.environment,
)