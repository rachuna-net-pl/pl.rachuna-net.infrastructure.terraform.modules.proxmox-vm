resource "proxmox_virtual_environment_vm" "vm" {

  name        = var.hostname
  description = var.description
  tags        = var.tags

  agent {
    enabled = true
  }

  pool_id    = var.pool_id
  node_name  = var.node_name
  vm_id      = var.vm_id
  protection = var.protection

  memory {
    dedicated = var.memory.dedicated
    floating  = var.memory.floating
  }

  cpu {
    cores   = var.cpu.cores
    sockets = var.cpu.sockets
    type    = var.cpu.type
  }

  clone {
    vm_id     = var.template.vm_id
    node_name = var.template.node_name
    full      = var.template.full == null ? true : var.template.full
  }

  initialization {
    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }

    user_account {
      keys     = [trimspace(var.technical_user.ssh_pub_key)]
      password = var.technical_user.password == null ? random_password.vm.result : var.technical_user.password
      username = var.technical_user.username
    }
  }

  network_device {
    bridge  = "vmbr0"
    vlan_id = var.is_dmz == true ? 20 : 10
  }

  operating_system {
    type = "l26"
  }
}

resource "random_password" "vm" {
  length           = 16
  override_special = "_%@"
  special          = true
}