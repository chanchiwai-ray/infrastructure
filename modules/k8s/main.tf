terraform {
  required_providers {
    juju = {
      version = ">= 1.1.1"
      source  = "juju/juju"
    }
  }
}

resource "juju_model" "k8s_model" {
  name = var.model_name

  cloud {
    name   = var.cloud_name
    region = var.cloud_region
  }
}

resource "juju_application" "k8s" {
  count      = var.k8s_units != 0 ? 1 : 0
  model_uuid = juju_model.k8s_model.uuid

  charm {
    name    = "k8s"
    base    = var.k8s_base
    channel = var.k8s_channel
  }

  units       = var.k8s_units
  config      = var.k8s_config
  constraints = var.k8s_constraints
}

resource "juju_application" "k8s_worker" {
  count      = var.k8s_worker_units != 0 ? 1 : 0
  model_uuid = juju_model.k8s_model.uuid

  charm {
    name    = "k8s-worker"
    base    = var.k8s_worker_base
    channel = var.k8s_worker_channel
  }

  units       = var.k8s_worker_units
  config      = var.k8s_worker_config
  constraints = var.k8s_worker_constraints
}

resource "juju_integration" "k8s_to_k8s_worker" {
  model_uuid = juju_model.k8s_model.uuid
  count      = var.k8s_units != 0 && var.k8s_worker_units != 0 ? 1 : 0

  application {
    name     = juju_application.k8s[0].name
    endpoint = "k8s-cluster"
  }

  application {
    name     = juju_application.k8s_worker[0].name
    endpoint = "cluster"
  }
}
