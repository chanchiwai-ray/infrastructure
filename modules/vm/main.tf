# https://registry.terraform.io/providers/terraform-lxd/lxd/latest/docs
terraform {
  required_providers {
    lxd = {
      source  = "terraform-lxd/lxd"
      version = "2.2.0"
    }
  }
}

resource "lxd_volume" "volumes" {
  count        = var.disks
  pool         = var.secondary_pool
  name         = "${var.node_name}-${count.index}"
  content_type = "block"

  config = {
    size = var.secondary_disk_size
  }
}

resource "lxd_instance" "machine" {
  name  = var.node_name
  image = var.image
  type  = "virtual-machine"

  config = {
    "boot.autostart"       = true
    "cloud-init.user-data" = <<-EOT
    #cloud-config

    users:
      - name: ubuntu
        shell: /bin/bash
        sudo: ALL=(ALL) NOPASSWD:ALL
        ssh_import_id:
          - ${var.ssh_import_id}

    prefer_fqdn_over_hostname: true

    snap:
      commands:
        - "snap install ${var.snap} --channel ${var.snap_channel}"
    EOT
  }

  limits = {
    cpu    = var.cpu
    memory = var.memory
  }

  device {
    name = "root"
    type = "disk"
    properties = {
      "path" = "/"
      "pool" = var.root_pool
      "size" = var.root_disk_size
    }
  }

  dynamic "device" {
    for_each = lxd_volume.volumes
    content {
      name = device.value.name
      type = "disk"
      properties = {
        "pool"   = device.value.pool
        "source" = device.value.name
      }
    }
  }

  execs = {
    "wait" = {
      command       = ["cloud-init", "status", "-w"]
      fail_on_error = true
    }
  }

}
