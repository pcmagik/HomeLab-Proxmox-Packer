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
  default = "Ubuntu 20.04 Template"
}

variable "template_name" {
  type    = string
  default = "packer-Ubuntu-20.04-Template"
}

variable "ubuntu_image" {
  type    = string
  default = "ubuntu-20.04.6-live-server-amd64.iso"
}

variable "version" {
  type    = string
  default = ""
}

source "proxmox-iso" "autogenerated_1" {
  boot_command = ["<enter><enter><f6><esc><wait> ", "autoinstall ds=nocloud-net;seedfrom=http://{{ .HTTPIP }}:{{ .HTTPPort }}/", "<enter><wait>"]
  boot_wait    = "5s"
  cores        = "4"
  disks {
    disk_size    = "8G"
    format       = "${var.proxmox_storage_format}"
    storage_pool = "${var.proxmox_storage_pool}"
    type         = "scsi"
  }
  http_directory           = "ubuntu2004/http"
  insecure_skip_tls_verify = true
  iso_file                 = "${var.proxmox_iso_pool}/${var.ubuntu_image}"
  memory                   = "2048"
  network_adapters {
    bridge = "vmbr0"
    model  = "virtio"
  }
  node                    = "${var.proxmox_node}"
  os                      = "l26"
  password                = "${var.proxmox_password}"
  proxmox_url             = "${var.proxmox_url}"
  scsi_controller         = "virtio-scsi-single"
  ssh_password            = "ubuntu"
  ssh_port                = 22
  ssh_timeout             = "30m"
  ssh_username            = "pcmagik"
  template_description    = "${var.template_description}"
  template_name           = "${var.template_name}"
  unmount_iso             = true
  cloud_init              = true
  cloud_init_storage_pool = "${var.proxmox_storage_pool}"
  username                = "${var.proxmox_username}"
  vm_id                   = "9050"
}

build {
  sources = ["source.proxmox-iso.autogenerated_1"]

  name = "proxmox-ubuntu2004"

  provisioner "shell" {
    inline = ["sudo rm -f /etc/cloud/cloud.cfg.d/99-installer.cfg", "sudo cloud-init clean"
    ]
  }

}
