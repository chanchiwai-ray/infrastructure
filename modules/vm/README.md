# Terraform module for LXD Virtual Machine

This terraform module assumes that you have already set up [LXD][lxd] in your machine. The installation can be as simple
as running the following:

```shell
# Install the required snaps
sudo snap install lxd

# If you have Docker installed, you may also need to configure the firewall
# see https://documentation.ubuntu.com/lxd/en/latest/howto/network_bridge_firewalld/#prevent-connectivity-issues-with-lxd-and-docker

# Initialize LXD
lxd init --auto
lxc network set lxdbr0 ipv6.address none  # optional, but need if you have Juju installed
```
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_lxd"></a> [lxd](#requirement\_lxd) | 2.2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_lxd"></a> [lxd](#provider\_lxd) | 2.2.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [lxd_instance.machine](https://registry.terraform.io/providers/terraform-lxd/lxd/2.2.0/docs/resources/instance) | resource |
| [lxd_volume.volumes](https://registry.terraform.io/providers/terraform-lxd/lxd/2.2.0/docs/resources/volume) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cpu"></a> [cpu](#input\_cpu) | The number of cpu cores for the virtual machine (default 1) | `number` | `1` | no |
| <a name="input_disks"></a> [disks](#input\_disks) | The number of secondary disks for the virtual machine (default 0) | `number` | `0` | no |
| <a name="input_image"></a> [image](#input\_image) | The image for the virtual machine (default ubuntu:24.04) | `string` | `"ubuntu:24.04"` | no |
| <a name="input_memory"></a> [memory](#input\_memory) | The amount of memory for the virtual machine (default 2GiB) | `string` | `"2GiB"` | no |
| <a name="input_node_name"></a> [node\_name](#input\_node\_name) | The name of node the virtual machine. | `string` | n/a | yes |
| <a name="input_root_disk_size"></a> [root\_disk\_size](#input\_root\_disk\_size) | The size of the root disk (default 10GiB) | `string` | `"10GiB"` | no |
| <a name="input_root_pool"></a> [root\_pool](#input\_root\_pool) | The storage pool for the root disk (default default) | `string` | `"default"` | no |
| <a name="input_secondary_disk_size"></a> [secondary\_disk\_size](#input\_secondary\_disk\_size) | The sizes of the secondary disks (default 10GiB each) | `string` | `"10GiB"` | no |
| <a name="input_secondary_pool"></a> [secondary\_pool](#input\_secondary\_pool) | The storage pool for the secondary disks | `string` | `"default"` | no |
| <a name="input_snap"></a> [snap](#input\_snap) | The snap to install. | `string` | n/a | yes |
| <a name="input_snap_channel"></a> [snap\_channel](#input\_snap\_channel) | The snap channel to install from. | `string` | n/a | yes |
| <a name="input_ssh_import_id"></a> [ssh\_import\_id](#input\_ssh\_import\_id) | Import the ssh key into the virtual machine | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_node"></a> [node](#output\_node) | The ipv4 address of the node. |
