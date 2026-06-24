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
  subnet_id           = dependency.vnet.outputs.subnet_id
  nsg_id              = dependency.nsg.outputs.nsg_id
}

dependency "vnet" {
  config_path = "../vnet"
  mock_outputs = {
    subnet_id = "mock-subnet-id"
  }
}

dependency "nsg" {
  config_path = "../nsg"
  mock_outputs = {
    nsg_id = "mock-nsg-id"
  }
}