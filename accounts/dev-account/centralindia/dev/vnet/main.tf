variable "location" {}
variable "resource_group_name" {}
variable "environment" {}
variable "project" {}

resource "azurerm_virtual_network" "this" {
  name                = "shalotrack-vnet"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = ["10.0.0.0/16"]

  tags = {
    Project     = var.project
    Environment = var.environment
  }
}

resource "azurerm_subnet" "this" {
  name                 = "shalotrack-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = ["10.0.1.0/24"]
}

output "subnet_id" {
  value = azurerm_subnet.this.id
}

output "vnet_name" {
  value = azurerm_virtual_network.this.name
}