include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "."
}

inputs = {
  location    = "centralindia"
  name        = "shalotrack-rg"
  environment = "dev"
  project     = "Shalotrack"
}