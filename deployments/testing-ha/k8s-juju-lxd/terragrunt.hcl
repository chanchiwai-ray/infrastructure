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
  k8s_channel     = "1.32/stable"
  k8s_constraints = "arch=amd64 cores=2 mem=4096M root-disk=20480M virt-type=virtual-machine"
  k8s_config = {
    load-balancer-enabled = true                        # enable load balancer feature
    load-balancer-cidrs   = "10.42.75.200-10.42.75.200" # use the IPs within the juju network (i.e. lxdbr0 network in this case)
    ingress-enabled       = true                        # enable ingress feature
    local-storage-enabled = true                        # enable local hostpath stroage
  }

  k8s_worker_units       = 2
  k8s_worker_base        = "ubuntu@24.04"
  k8s_worker_channel     = "1.32/stable"
  k8s_worker_constraints = "arch=amd64 cores=2 mem=4096M root-disk=40960M virt-type=virtual-machine"
  k8s_worker_config      = {}
}
