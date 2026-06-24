variable "location" {}
variable "name" {}
variable "environment" {}
variable "project" {}

resource "azurerm_resource_group" "this" {
  name     = var.name
  location = var.location

  tags = {
    Project     = var.project
    Environment = var.environment
    ManagedBy   = "Terragrunt"
  }
}

output "resource_group_name" {
  value = azurerm_resource_group.this.name
}

output "location" {
  value = azurerm_resource_group.this.location
}