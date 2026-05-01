terraform {
  source = "https://github.com/chanchiwai-ray/infrastructure.git/modules/k8s"

  after_hook "wait-for-model-ready" {
    commands = ["apply"]
    execute  = ["${get_repo_root()}/shared/hooks/wait-for-model-ready.sh", "k8s"]
  }

  after_hook "get-kubeconfig" {
    commands = ["apply"]
    execute  = ["${get_repo_root()}/shared/hooks/get-kubeconfig.sh"]
  }

  after_hook "wait-for-model-destroyed" {
    commands = ["destroy"]
    execute  = ["${get_repo_root()}/shared/hooks/wait-for-model-destroy.sh", "k8s"]
  }
}

inputs = {
  # Usually they are used for local LXD cloud
  cloud_name   = "localhost"
  cloud_region = "localhost"

  k8s_units       = 1
  k8s_base        = "ubuntu@24.04"
  k8s_channel     = "1.35/stable"
  k8s_constraints = "arch=amd64 cores=2 mem=4096M root-disk=40960M virt-type=virtual-machine"
  k8s_config = {
    gateway-enabled       = true                 # enable gateway
    local-storage-enabled = true                 # enable local hostpath stroage
    load-balancer-enabled = true                 # enable load balancer feature
    load-balancer-l2-mode = true                 # enable load balancer l2 mode
    load-balancer-cidrs   = "10.8.0.5-10.8.0.15" # virutal IPs for load balancer
  }

  k8s_worker_units       = 2
  k8s_worker_base        = "ubuntu@24.04"
  k8s_worker_channel     = "1.35/stable"
  k8s_worker_constraints = "arch=amd64 cores=2 mem=4096M root-disk=40960M virt-type=virtual-machine"
  k8s_worker_config      = {}
}
