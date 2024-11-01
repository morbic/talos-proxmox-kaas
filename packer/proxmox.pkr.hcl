packer {
  required_plugins {
    proxmox = {
      version = ">= 1.0.1"
      source  = "github.com/hashicorp/proxmox"
    }
  }
}

source "proxmox" "talos" {
  proxmox_url              = var.proxmox_url
  username                 = var.proxmox_username
  token                    = var.proxmox_token
  node                     = var.proxmox_nodename
  insecure_skip_tls_verify = true

  iso_file    = "local:iso/archlinux-2024.10.01-x86_64.iso"
  unmount_iso = true

  scsi_controller = "virtio-scsi-pci"
  network_adapters {
    bridge = "vmbr20-k8s-mgmt"
    model  = "virtio"
  }
  disks {
    type              = "virtio"
    storage_pool      = var.proxmox_storage
    storage_pool_type = var.proxmox_storage_type
    format            = "raw"
    disk_size         = "1500M"
    cache_mode        = "writethrough"
  }

  memory       = 2048
  ssh_username = "root"
  ssh_password = "packer"
  ssh_timeout  = "15m"
  qemu_agent   = true

  template_name        = "talos"
  template_description = "Talos system disk"

  boot_wait = "25s"
  boot_command = [
    "<enter><wait1m>",
    "passwd<enter><wait>packer<enter><wait>packer<enter>",
    "ip address add ${var.static_ip} broadcast + dev ens18<enter><wait>",
    "ip route add 0.0.0.0/0 via ${var.gateway} dev ens18<enter><wait>"
  ]
}

build {
  name    = "release"
  sources = ["source.proxmox.talos"]

  provisioner "shell" {
    inline = [
      "curl -L ${local.image} -o /tmp/talos.raw.xz",
      "xz -d -c /tmp/talos.raw.xz | dd of=/dev/vda && sync",
    ]
  }
}
