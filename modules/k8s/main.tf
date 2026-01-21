terraform {
  required_providers {
    juju = {
      version = ">= 1.1.1"
      source  = "juju/juju"
    }
  }
}


resource "juju_model" "k8s_model" {
  name = "k8s"

  cloud {
    name   = var.cloud_name
    region = var.cloud_region
  }
}

module "k8s" {
  source = "git::https://github.com/canonical/k8s-operator//charms/worker/k8s/terraform?ref=main"
  count  = var.k8s_units != 0 ? 1 : 0

  units      = var.k8s_units
  model_uuid = juju_model.k8s_model.uuid

  base        = var.k8s_base
  channel     = var.k8s_channel
  constraints = var.k8s_constraints

  config = var.k8s_config

}

module "k8s_worker" {
  source = "git::https://github.com/canonical/k8s-operator//charms/worker/terraform?ref=main"
  count  = var.k8s_worker_units != 0 ? 1 : 0

  units      = var.k8s_worker_units
  model_uuid = juju_model.k8s_model.uuid

  base        = var.k8s_worker_base
  channel     = var.k8s_worker_channel
  constraints = var.k8s_worker_constraints

  config = var.k8s_worker_config

}

resource "juju_integration" "k8s_to_k8s_worker" {
  model_uuid = juju_model.k8s_model.uuid
  count      = var.k8s_units != 0 && var.k8s_worker_units != 0 ? 1 : 0

  application {
    name     = module.k8s[0].app_name
    endpoint = "k8s-cluster"
  }

  application {
    name     = module.k8s_worker[0].app_name
    endpoint = "cluster"
  }
}
