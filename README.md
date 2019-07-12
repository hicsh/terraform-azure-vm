# terraform-azure-vm

### Usage

```
variable "prefix" {
	type = "string"
	default = "dev"
}

resource "azurerm_virtual_network" "private_network" {
  	name                = "${var.prefix}-network"
  	address_space       = ["10.2.0.0/16"]
	location = "northeurope"
	resource_group = "my-resource-group"

module "vm_web-server" {
	source = "../shared/modules/vm"
	vm_name = "${var.prefix}-web-server"
	vm_size = "Standard_F1"

	vm_location = "northeurope"
	vm_resource_group = "my-resource-group"
	vm_subnet_id = "${azurerm_subnet.private_network_subnet.id}"
	vm_admin_passwd = "USE_VAULT"

	vm_data_disk_name = ["${var.prefix}-web-server-data-disk"]
	vm_data_disk_size = [20]

	vm_diagnostic_disk_uri = ""
	vm_ssh_pubkey = "${var.my_ssh_key}"

	vm_domain_name_label = "${var.prefix}-some-domain"
}
```

### Provisioning

In your `terraform` project root directory create `provision/bootstrap.sh.tpl` template.
