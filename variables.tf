variable "vm_count" {
  type    = "string"
  default = 1
}

variable "vm_name" {
  type = "string"
}

variable "vm_location" {
  type = "string"
}

variable "vm_resource_group" {
  type = "string"
}

variable "vm_subnet_id" {
  type = "string"
}

variable "vm_size" {
  type    = "string"
  default = "Standard_F1"
}

variable "storage_tier" {
  type    = "string"
  default = "Standard_LRS"
}

variable "vm_admin_name" {
  type    = "string"
  default = "VMAdmin"
}

variable "vm_admin_passwd" {
  type = "string"
}

variable "vm_data_disk_name" {
  type = "list"
}

variable "vm_data_disk_size" {
  type = "list"
}

variable "vm_publisher_name" {
  type = "string"
  default = "Canonical"
}

variable "vm_offer" {
  type = "string"
  default = "UbuntuServer"
}

variable "vm_sku" {
  type = "string"
  default = "18.04-LTS"
}

variable "vm_diagnostic_disk_uri" {
  type = "string"
}

variable "vm_ssh_pubkey" {
  type = "string"
}

variable "vm_environment_tag" {
  type    = "string"
  default = "Poc"
}

# DNS

variable "vm_domain_name_label" {
  type    = "string"
}

# PROVISIONING

variable "vm_provisioning_plan" {
  type    = "string"
}

variable "vm_cloud_init_script_path" {
  type = "string"
  default = "provision/bootstrap.sh.tpl"
}

data "template_file" "cloudconfig" {
  template = "${file("${var.vm_cloud_init_script_path}")}"

  vars = {
    provisioning_plan = "${var.vm_provisioning_plan}"
  }
}

#https://www.terraform.io/docs/providers/template/d/cloudinit_config.html
data "template_cloudinit_config" "config" {
  gzip          = true
  base64_encode = true

  part {
    content = "${data.template_file.cloudconfig.rendered}"
  }
}