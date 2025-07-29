output "nodes" {
  value       = module.lxd_instances.*.node
  description = "The ipv4 address of the nodes."
}
