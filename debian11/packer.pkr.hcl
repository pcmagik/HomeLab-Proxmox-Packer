packer {
  required_plugins {
    proxmox = {
      version = ">= 1.1.6"
      source  = "github.com/hashicorp/proxmox"
    }
  }
}

variable "proxmox_iso_pool" {
  type    = string
  default = ""
}

variable "proxmox_node" {
  type    = string
  default = ""
}

variable "proxmox_password" {
  type    = string
  default = ""
}

variable "proxmox_storage_format" {
  type    = string
  default = ""
}

variable "proxmox_storage_pool" {
  type    = string
  default = ""
}

variable "proxmox_storage_pool_type" {
  type    = string
  default = ""
}

variable "proxmox_url" {
  type    = string
  default = ""
}

variable "proxmox_username" {
  type    = string
  default = ""
}

variable "template_description" {
  type    = string
  default = "Debian 11.0 Template"
}

variable "template_name" {
  type    = string
  default = "packer-Debian-11.0-Template"
}

variable "debian_image" {
  type    = string
  default = "debian-11.0.0-amd64-netinst.iso"
}

variable "version" {
  type    = string
  default = ""
}




# Boot Configuration
source "proxmox-iso" "autogenerated_1" {
  boot_command = ["<esc><wait>", "install <wait>", " preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg <wait>", "debian-installer=en_GB.UTF-8 <wait>", "auto <wait>",
    "locale=en_GB.UTF-8 <wait>", "kbd-chooser/method=gb <wait>", "keyboard-configuration/xkb-keymap=gb <wait>", "netcfg/get_hostname=pkr-template-debian <wait>", "netcfg/get_domain=local.domain <wait>",
    "fb=false <wait>", "debconf/frontend=noninteractive <wait>",
  "console-setup/ask_detect=false <wait>", "console-keymaps-at/keymap=gb <wait>", "grub-installer/bootdev=/dev/sda <wait>", "<enter><wait>"]
  boot_wait = "5s"

  # VM Configuration
  cores = "4"
  disks {
    disk_size    = "8G"
    format       = "${var.proxmox_storage_format}"
    storage_pool = "${var.proxmox_storage_pool}"
    type         = "scsi"
  }
  http_directory           = "debian11/http"
  insecure_skip_tls_verify = true
  iso_file                 = "${var.proxmox_iso_pool}/${var.debian_image}"
  memory                   = "2048"
  network_adapters {
    bridge = "vmbr0"
  }
  node                    = "${var.proxmox_node}"
  os                      = "l26"
  password                = "${var.proxmox_password}"
  proxmox_url             = "${var.proxmox_url}"
  scsi_controller         = "virtio-scsi-single"
  communicator            = "ssh"
  ssh_password            = "Mniam123!"
  ssh_port                = 22
  ssh_timeout             = "30m"
  ssh_username            = "pcmagik"
  template_description    = "${var.template_description}"
  template_name           = "${var.template_name}"
  unmount_iso             = true
  cloud_init              = true
  cloud_init_storage_pool = "${var.proxmox_storage_pool}"
  username                = "${var.proxmox_username}"
  vm_id                   = "9021"
  ssh_private_key_file    = "~/.ssh/id_rsa"
}

build {
  sources = ["source.proxmox-iso.autogenerated_1"]

  name = "proxmox-debian11"

  provisioner "shell" {
    inline = [
      "which cloud-init || (sudo apt-get update && sudo apt-get install -y cloud-init)",
      "cloud-init status --wait",
      "sudo rm -f /etc/cloud/cloud.cfg.d/99-installer.cfg",
      "sudo cloud-init clean"
    ]
  }

}
