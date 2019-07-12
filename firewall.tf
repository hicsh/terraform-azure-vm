resource "azurerm_network_security_group" "vm_security_group" {
  name     = "vm_${var.vm_name}${count.index+1}_security_group"
  location              = "${var.vm_location}"
  resource_group_name   = "${var.vm_resource_group}"
}

##### FW RULES

### INBOUND

resource "azurerm_network_security_rule" "allow_ssh" {
  name                        = "vm_fw_rule_${var.vm_name}${count.index+1}_allow_ssh"
  priority                    = 1001
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name   = "${var.vm_resource_group}"
  network_security_group_name = "${azurerm_network_security_group.vm_security_group.name}"
}
