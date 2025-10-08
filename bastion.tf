# resource "azurerm_resource_group" "main" {
#   name     = "${var.prefix}-resources"
#   location = "East US"
# }

# resource "azurerm_virtual_network" "main" {
#   name                = "${var.prefix}-network"
#   address_space       = ["10.128.0.0/16"]
#   location            = azurerm_resource_group.main.location
#   resource_group_name = azurerm_resource_group.main.name
# }

# resource "azurerm_subnet" "internal" {
#   name                 = "internal"
#   resource_group_name  = azurerm_resource_group.main.name
#   virtual_network_name = azurerm_virtual_network.main.name
#   address_prefixes     = ["10.128.2.0/24"]
# }

# resource "azurerm_public_ip" "pip" {
#   name                = "${var.prefix}-pip"
#   resource_group_name = azurerm_resource_group.main.name
#   location            = azurerm_resource_group.main.location
#   allocation_method   = "Static"
# }

# resource "azurerm_network_interface" "main" {
#   name                = "${var.prefix}-nic1"
#   resource_group_name = azurerm_resource_group.main.name
#   location            = azurerm_resource_group.main.location

#   ip_configuration {
#     name                          = "primary"
#     subnet_id                     = azurerm_subnet.internal.id
#     private_ip_address_allocation = "Dynamic"
#     public_ip_address_id          = azurerm_public_ip.pip.id
#   }
# }

# resource "azurerm_network_interface" "internal" {
#   name                = "${var.prefix}-nic2"
#   resource_group_name = azurerm_resource_group.main.name
#   location            = azurerm_resource_group.main.location

#   ip_configuration {
#     name                          = "internal"
#     subnet_id                     = azurerm_subnet.internal.id
#     private_ip_address_allocation = "Dynamic"
#   }
# }

# resource "azurerm_network_security_group" "ssh" {
#   name                = "ssh"
#   location            = azurerm_resource_group.main.location
#   resource_group_name = azurerm_resource_group.main.name
#   security_rule {
#     access                     = "Allow"
#     direction                  = "Inbound"
#     name                       = "ssh"
#     priority                   = 100
#     protocol                   = "Tcp"
#     source_port_range          = "*"
#     source_address_prefixes    = var.juniper_junction
#     destination_port_range     = "22"
#     destination_address_prefix = azurerm_network_interface.main.private_ip_address
#   }
# }

# resource "azurerm_network_interface_security_group_association" "main" {
#   network_interface_id      = azurerm_network_interface.main.id
#   network_security_group_id = azurerm_network_security_group.ssh.id
# }

# resource "azurerm_linux_virtual_machine" "main" {
#   name                            = "${var.prefix}-vm"
#   resource_group_name             = azurerm_resource_group.main.name
#   location                        = azurerm_resource_group.main.location
#   size                            = "Standard_B2s"
#   disable_password_authentication = true
#   network_interface_ids = [
#     azurerm_network_interface.main.id,
#     azurerm_network_interface.internal.id,
#   ]

#   admin_username = "adminuser" #WHY
#   admin_ssh_key {
#     username   = "adminuser"
#     public_key = <<EOF
# ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC48Ys2HvlHglzLbwdfxt9iK2LATImoH8VG9vWzvuiRIsa8UQxbLbk6Gutx3MpB2FZywB3ZrZfw5MqivAtJXE2Os/QmgAZQxRpV15BTzrgvbqTKyibKnmRsCG59O8icftREKY6q/gvzr67QcMhMEZLDExS8c+zycQT1xCVg1ip5PwPAwMQRxtqLvV/5B85IsJuMZi3YymYaVSJgayYBA2eM/M8YInlIDKNqekHL/cUZFG2TP98NOODsY4kRyos4c8+jkULLCOGu0rLhA7rP3NsvEbcpCOI2lS5XgxnOHIpZ42V2xGId8IRDtK4wEGAHEWmOKdOsL4Qe5AwglHMmdkZU2HKdThOb5+8pf5BDe/I9aLB3k7vW5jcOm1dyHZ0pg/Tg9hJdFCCSBm0E4EJDRzI223chgwjf+XrMDB7DHTa29KU63rDeQme89y57HkgxXCIq4EVUKRaJS1PIUI7uJKMDryd2Au/W9z4nAbindFIxHMg/eC1aW0k90ri8FebvkX0=
#     EOF
#   }

#   source_image_reference {
#     publisher = "Canonical"
#     offer     = "ubuntu-24_04-lts"
#     sku       = "server"
#     version   = "latest"
#   }

#   os_disk {
#     storage_account_type = "Standard_LRS"
#     caching              = "ReadWrite"
#   }
# }
