
resource "azurerm_public_ip" "vm_public_ip" {
  name                = "public_ip_${var.vm_name}${count.index+1}"
  location            = "${var.vm_location}"
  resource_group_name = "${var.vm_resource_group}"
  allocation_method   = "Static"

  domain_name_label	  = "${var.vm_domain_name_label}"

}

resource "azurerm_network_interface" "vm_nic" {
  name                = "nic-${var.vm_name}${count.index+1}"
  location            = "${var.vm_location}"
  resource_group_name = "${var.vm_resource_group}"
  network_security_group_id = "${azurerm_network_security_group.vm_security_group.id}"

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = "${var.vm_subnet_id}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = "${azurerm_public_ip.vm_public_ip.id}"
  }
}


