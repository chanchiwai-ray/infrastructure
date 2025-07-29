terraform {
  source = "https://github.com/chanchiwai-ray/infrastructure.git/modules/vm"
  extra_arguments "global_vars" {
    commands = [
      "apply",
      "import",
      "plan",
      "push",
      "refresh"
    ]
  }

  after_hook "bootstrap" {
    commands     = ["apply"]
    execute      = ["./hooks/bootstrap.sh"]
    run_on_error = true
  }

  after_hook "add-to-known-hosts" {
    commands     = ["apply"]
    execute      = ["./hooks/add_to_known_hosts.sh"]
    run_on_error = true
  }

  before_hook "remove-from-known-hosts" {
    commands     = ["destroy"]
    execute      = ["./hooks/remove_from_known_hosts.sh"]
    run_on_error = true
  }

}

inputs = {
  ssh_import_id       = "gh:chanchiwai-ray"
  node_name           = "microceph"
  image               = "ubuntu:24.04"
  num                 = 1
  cpu                 = 2
  disks               = 3
  memory              = "4GiB"
  snap                = "microceph"
  snap_channel        = "squid/stable"
  root_pool           = "default"
  root_disk_size      = "30GiB"
  secondary_pool      = "main"
  secondary_disk_size = "20GiB"
}
