output "bastion_ip" {
  value = azurerm_public_ip.pip.ip_address
}
