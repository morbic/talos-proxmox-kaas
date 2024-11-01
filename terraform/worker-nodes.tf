resource "proxmox_vm_qemu" "workers" {
  count       = 3
  name        = "k8s-worker-${count.index}"
  target_node = var.target_node_name
  clone       = var.proxmox_image

  vmid                    = 210 + count.index + 1
  agent                   = 1
  define_connection_info  = false
  os_type                 = "cloud-init"
  qemu_os                 = "l26"
  ipconfig0               = "ip=${cidrhost(var.vpc_main_cidr, var.worker_first_ip + "${count.index}")}/24,gw=${var.gateway}"

  onboot  = false
  cpu     = "host"
  sockets = 1
  cores   = 4
  memory  = 8048
  scsihw  = "virtio-scsi-pci"

  vga {
    memory = 0
    type   = "serial0"
  }
  serial {
    id   = 0
    type = "socket"
  }

  network {
    model    = "virtio"
    bridge   = "vmbr20-k8s-mgmt"
    firewall = false
  }

  boot = "order=virtio0"
  disks {
    ide {
      ide3 {
        cloudinit {
          storage = var.proxmox_storage_nvme
        }
      }
    }

    virtio {
      virtio0 {
        disk {
          size            = 40
          cache           = "writethrough"
          storage         = var.proxmox_storage_nvme
          iothread        = true
          discard         = true
        }
      }
    }
  }

  lifecycle {
    ignore_changes = [
      boot,
      network,
      desc,
      numa,
      agent,
      ipconfig0,
      ipconfig1,
      define_connection_info,
    ]
  }
}