terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.14.0"
    }
  }
}

provider "azurerm" {
  subscription_id = "xxxxxxxxxxxxxxxxx"
  client_id       = "xxxxxxxxxxxxxxxxxx"
  client_secret   = "xxxxxxxxxxxxxxxxxx"
  tenant_id       = "yyyyyyyyyyyyyyyyyyyyyyy"
  features {}

}

resource "azurerm_resource_group" "myresourcegroup" {
  name     = "${var.prefix}-group"
  location = var.location

  tags = {
    environment = "Production"
  }
}

# resource "tls_private_key" "linux_key" {
#   algorithm = "RSA"
#   rsa_bits  = 4096
# }
# # We want to save the private key to our machine
# # We can then use this key to connect to our Linux VM
#
# resource "local_file" "linuxkey" {
#   filename = "linuxkey.pem"
#   content  = tls_private_key.linux_key.private_key_pem
# }
#
# resource "azurerm_virtual_network" "vnet" {
#   name                = "${var.prefix}-vnet"
#   location            = azurerm_resource_group.myresourcegroup.location
#   address_space       = [var.address_space]
#   resource_group_name = azurerm_resource_group.myresourcegroup.name
# }
#
# resource "azurerm_subnet" "subnet" {
#   name                 = "${var.prefix}-subnet"
#   virtual_network_name = azurerm_virtual_network.vnet.name
#   resource_group_name  = azurerm_resource_group.myresourcegroup.name
#   address_prefixes     = [var.subnet_prefix]
# }
#
# resource "azurerm_network_security_group" "catapp-sg" {
#   name                = "${var.prefix}-sg"
#   location            = var.location
#   resource_group_name = azurerm_resource_group.myresourcegroup.name
#
#   security_rule {
#     name                       = "HTTP"
#     priority                   = 100
#     direction                  = "Inbound"
#     access                     = "Allow"
#     protocol                   = "Tcp"
#     source_port_range          = "*"
#     destination_port_range     = "80"
#     source_address_prefix      = "*"
#     destination_address_prefix = "*"
#   }
#
#   security_rule {
#     name                       = "HTTPS"
#     priority                   = 102
#     direction                  = "Inbound"
#     access                     = "Allow"
#     protocol                   = "Tcp"
#     source_port_range          = "*"
#     destination_port_range     = "443"
#     source_address_prefix      = "*"
#     destination_address_prefix = "*"
#   }
#
#   security_rule {
#     name                       = "SSH"
#     priority                   = 101
#     direction                  = "Inbound"
#     access                     = "Allow"
#     protocol                   = "Tcp"
#     source_port_range          = "*"
#     destination_port_range     = "22"
#     source_address_prefix      = "*"
#     destination_address_prefix = "*"
#   }
# }
#
#
# resource "azurerm_network_interface" "catapp-nic" {
#   name                = "${var.prefix}-catapp-nic"
#   location            = var.location
#   resource_group_name = azurerm_resource_group.myresourcegroup.name
#
#   ip_configuration {
#     name                          = "${var.prefix}ipconfig"
#     subnet_id                     = azurerm_subnet.subnet.id
#     private_ip_address_allocation = "Dynamic"
#     public_ip_address_id          = azurerm_public_ip.catapp-pip.id
#   }
# }
#
# resource "azurerm_virtual_machine" "catapp" {
#   name                          = "${var.prefix}-meow"
#   location                      = var.location
#   resource_group_name           = azurerm_resource_group.myresourcegroup.name
#   vm_size                       = var.vm_size
#   admin_username                = "adminuser"
#   network_interface_ids         = [azurerm_network_interface.catapp-nic.id]
#   delete_os_disk_on_termination = "true"
#
#   admin_ssh_key {
#     username   = "adminuser"
#     public_key = tls_private_key.linux_key.public_key_openssh
#   }
#
#   os_disk {
#     caching              = "ReadWrite"
#     storage_account_type = "Standard_LRS"
#   }
#
#   source_image_reference {
#     publisher = "Canonical"
#     offer     = "UbuntuServer"
#     sku       = "20.04-LTS"
#     version   = "latest"
#   }
#   depends_on = [azurerm_network_interface_security_group_association.catapp-nic-sg-ass, tls_private_key.linux_key]
# }
