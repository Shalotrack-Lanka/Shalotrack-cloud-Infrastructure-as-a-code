include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "."
}

inputs = {
  location            = "centralindia"
  resource_group_name = "shalotrack-rg"
  environment         = "dev"
  project             = "Shalotrack"
}