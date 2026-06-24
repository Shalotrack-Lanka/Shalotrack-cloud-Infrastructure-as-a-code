variable "location" {}
variable "resource_group_name" {}
variable "environment" {}
variable "project" {}
variable "subnet_id" {}
variable "nsg_id" {}

resource "azurerm_public_ip" "this" {
  name                = "shalotrack-public-ip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"

  tags = {
    Project     = var.project
    Environment = var.environment
  }
}

resource "azurerm_network_interface" "this" {
  name                = "shalotrack-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.this.id
  }

  tags = {
    Project     = var.project
    Environment = var.environment
  }
}

resource "azurerm_network_interface_security_group_association" "this" {
  network_interface_id      = azurerm_network_interface.this.id
  network_security_group_id = var.nsg_id
}

resource "azurerm_linux_virtual_machine" "this" {
  name                = "shalotrack-vm"
  location            = var.location
  resource_group_name = var.resource_group_name
  size                = "Standard_B2s"
  admin_username      = "shalotrackadmin"

  network_interface_ids = [
    azurerm_network_interface.this.id
  ]

  admin_ssh_key {
    username   = "shalotrackadmin"
    public_key = file("~/.ssh/shalotrack.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
    disk_size_gb         = 30
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  tags = {
    Project     = var.project
    Environment = var.environment
  }
}

output "vm_public_ip" {
  value = azurerm_public_ip.this.ip_address
}

output "vm_name" {
  value = azurerm_linux_virtual_machine.this.name
}