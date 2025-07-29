# https://registry.terraform.io/providers/terraform-lxd/lxd/latest/docs
terraform {
  required_providers {
    lxd = {
      source  = "terraform-lxd/lxd"
      version = "2.2.0"
    }
  }
}

module "lxd_instances" {
  count  = var.num
  source = "git::https://github.com/chanchiwai-ray/infrastructure.git//modules/vm"

  ssh_import_id       = var.ssh_import_id
  node_name           = "${var.node_prefix}-${count.index}"
  image               = var.image
  cpu                 = var.cpu
  disks               = var.disks
  memory              = var.memory
  snap                = var.snap
  snap_channel        = var.snap_channel
  root_pool           = var.root_pool
  root_disk_size      = var.root_disk_size
  secondary_pool      = var.secondary_pool
  secondary_disk_size = var.secondary_disk_size
}
