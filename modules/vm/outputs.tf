output "node" {
  value       = lxd_instance.machine.ipv4_address
  description = "The ipv4 address of the node."
}
