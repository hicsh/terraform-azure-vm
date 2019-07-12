resource "azurerm_virtual_machine" "general_purpose_vm" {
  name                  = "${var.vm_name}${count.index+1}"
  location              = "${var.vm_location}"
  resource_group_name   = "${var.vm_resource_group}"
  network_interface_ids = ["${azurerm_network_interface.vm_nic.id}"]
  vm_size               = "${var.vm_size}"

  delete_os_disk_on_termination = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "${var.vm_publisher_name}"

    offer   = "${var.vm_offer}"
    sku     = "${var.vm_sku}"
    version = "latest"
  }

  storage_os_disk {
    name              = "${var.vm_name}${count.index+1}-OSDisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "${var.storage_tier}"
  }

  storage_data_disk {
    name            = "${element(var.vm_data_disk_name,count.index)}"
    managed_disk_type = "${var.storage_tier}"
    create_option   = "Empty"
    lun             = 0
    disk_size_gb    = "${element(var.vm_data_disk_size,count.index)}"
  }

  boot_diagnostics {
    enabled = true
    storage_uri = "${azurerm_storage_account.boot_diagnostics_storage_account.primary_blob_endpoint}"
  }

  os_profile {
    computer_name  = "${var.vm_name}"
    admin_username = "${var.vm_admin_name}"
    admin_password = "${var.vm_admin_passwd}"
    custom_data    = "${data.template_cloudinit_config.config.rendered}"
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      path     = "/home/${var.vm_admin_name}/.ssh/authorized_keys"
      key_data = "${var.vm_ssh_pubkey}"
    }
  }

  tags {
    name = "${var.vm_name}"
    environment = "${var.vm_environment_tag}"
  }
}
