variable "ssh_import_id" {
  type        = string
  description = "Import the ssh key into the virtual machine"
}

variable "node_name" {
  type        = string
  description = "The name of node the virtual machine."
}

variable "image" {
  type        = string
  default     = "ubuntu:24.04"
  description = "The image for the virtual machine (default ubuntu:24.04)"
}

variable "cpu" {
  type        = number
  default     = 1
  description = "The number of cpu cores for the virtual machine (default 1)"
}

variable "disks" {
  type        = number
  default     = 0
  description = "The number of secondary disks for the virtual machine (default 0)"
}

variable "memory" {
  type        = string
  default     = "2GiB"
  description = "The amount of memory for the virtual machine (default 2GiB)"
}

variable "snap" {
  type        = string
  description = "The snap to install."
}
variable "snap_channel" {
  type        = string
  description = "The snap channel to install from."
}

variable "root_pool" {
  type        = string
  default     = "default"
  description = "The storage pool for the root disk (default default)"
}

variable "root_disk_size" {
  type        = string
  default     = "10GiB"
  description = "The size of the root disk (default 10GiB)"
}

variable "secondary_pool" {
  type        = string
  default     = "default"
  description = "The storage pool for the secondary disks"
}

variable "secondary_disk_size" {
  type        = string
  default     = "10GiB"
  description = "The sizes of the secondary disks (default 10GiB each)"
}
