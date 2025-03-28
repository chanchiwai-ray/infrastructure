output "node" {
  value       = "ubuntu@${lxd_instance.machine.ipv4_address}"
  description = "The <username>@<ipv4_address>."
}
