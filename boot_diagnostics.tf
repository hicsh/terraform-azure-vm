resource "azurerm_storage_account" "boot_diagnostics_storage_account" {
  name                     = "vm${var.vm_name}bootdiag"
  resource_group_name      = "${var.vm_resource_group}"
  location                 = "${var.vm_location}"
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    purpose = "vm_boot_diagnostics"
    vm = "${var.vm_name}"
  }

}