variable "cloud_name" {
  type        = string
  description = "Name of the cloud"
}

variable "cloud_region" {
  type        = string
  description = "Region of the cloud"
}

variable "k8s_units" {
  type        = number
  description = "Number of units for k8s control plane"
  default     = 1
}

variable "k8s_base" {
  type        = string
  description = "The base of the k8s charm"
  default     = "ubuntu@24.04"
}

variable "k8s_channel" {
  type        = string
  description = "The channel of the k8s charm"
  default     = "1.32/stable"
}

variable "k8s_constraints" {
  type        = string
  description = "The juju constraints for k8s units"
  default     = "arch=amd64 cores=2 mem=4096M root-disk=20480M virt-type=virtual-machine"
}

variable "k8s_config" {
  type        = map(string)
  description = "The juju config for k8s units"
  default     = {}
}

variable "k8s_worker_units" {
  type        = number
  description = "Number of units for k8s data plane"
  default     = 2
}

variable "k8s_worker_base" {
  type        = string
  description = "The base of the k8w worker charm"
  default     = "ubuntu@24.04"
}

variable "k8s_worker_channel" {
  type        = string
  description = "The channel of the k8w worker charm"
  default     = "1.32/stable"
}

variable "k8s_worker_constraints" {
  type        = string
  description = "The juju constraints for k8w worker units"
  default     = "arch=amd64 cores=2 mem=4096M root-disk=40960M virt-type=virtual-machine"
}

variable "k8s_worker_config" {
  type        = map(string)
  description = "The juju config for k8w worker units"
  default     = {}
}
