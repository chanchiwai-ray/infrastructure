terraform {
  source = "https://github.com/chanchiwai-ray/infrastructure.git/modules/vms"
  extra_arguments "global_vars" {
    commands = [
      "apply",
      "import",
      "plan",
      "push",
      "refresh"
    ]
  }

  after_hook "add-to-known-hosts" {
    commands     = ["apply"]
    execute      = ["./hooks/add_to_known_hosts.sh"]
    run_on_error = true
  }

  after_hook "init-machines" {
    commands     = ["apply"]
    execute      = ["./hooks/init.sh"]
    run_on_error = true
  }

  before_hook "remove-from-known-hosts" {
    commands     = ["destroy"]
    execute      = ["./hooks/remove_from_known_hosts.sh"]
    run_on_error = true
  }
}

inputs = {
  ssh_import_id  = "gh:chanchiwai-ray"
  node_prefix    = "k8s"
  image          = "ubuntu:24.04"
  num            = 4
  cpu            = 2
  disks          = 0
  memory         = "4GiB"
  snap           = "hello-world"   # dummy snap
  snap_channel   = "latest/stable" # dummy snap channel
  root_pool      = "default"
  root_disk_size = "30GiB"

}
