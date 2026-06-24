variable "location" {}
variable "resource_group_name" {}
variable "environment" {}
variable "project" {}

resource "azurerm_container_registry" "this" {
  name                = "shalotrackcr"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Basic"
  admin_enabled       = true

  tags = {
    Project     = var.project
    Environment = var.environment
  }
}

output "acr_login_server" {
  value = azurerm_container_registry.this.login_server
}

output "acr_name" {
  value = azurerm_container_registry.this.name
}