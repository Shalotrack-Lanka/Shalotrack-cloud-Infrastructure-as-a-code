include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "tfr:///Azure/resource-group/azurerm//?version=1.1.0"
}

inputs = {
  location = "centralindia"
  name     = "shalotrack-rg"

  tags = {
    Project     = "Shalotrack"
    Environment = "dev"
    ManagedBy   = "Terragrunt"
  }
}