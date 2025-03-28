# Terraform module for Canonical Kubernetes on LXD virtual machines

This terraform module assumes that you have already setup a [Juju][juju] controller and bootstrap the Juju controller to
a local [LXD][lxd] cloud. The installation can be as simple as running the following:

```shell
# Install the required snaps
sudo snap install lxd
sudo snap install juju

# If you have Docker installed, you may also need to configure the firewall
# see https://documentation.ubuntu.com/lxd/en/latest/howto/network_bridge_firewalld/#prevent-connectivity-issues-with-lxd-and-docker

# Initialize LXD
lxd init --auto
lxc network set lxdbr0 ipv6.address none

# Bootstrap juju controller to a local LXD cloud
juju bootstrap localhost overlord
```

For more information about the steps above, please refer to the [offical documentation][juju-docs].

## Terraform Module

<!-- BEGIN_TF_DOCS -->
### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_juju"></a> [juju](#requirement\_juju) | ~> 0.17.0 |

### Providers

| Name | Version |
|------|---------|
| <a name="provider_juju"></a> [juju](#provider\_juju) | ~> 0.17.0 |

### Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_k8s"></a> [k8s](#module\_k8s) | git::https://github.com/canonical/k8s-operator//charms/worker/k8s/terraform | main |
| <a name="module_k8s_worker"></a> [k8s\_worker](#module\_k8s\_worker) | git::https://github.com/canonical/k8s-operator//charms/worker/terraform | main |

### Resources

| Name | Type |
|------|------|
| [juju_integration.k8s_to_k8s_worker](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_model.k8s_model](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/model) | resource |

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloud_name"></a> [cloud\_name](#input\_cloud\_name) | Name of the cloud | `string` | n/a | yes |
| <a name="input_cloud_region"></a> [cloud\_region](#input\_cloud\_region) | Region of the cloud | `string` | n/a | yes |
| <a name="input_k8s_base"></a> [k8s\_base](#input\_k8s\_base) | The base of the k8s charm | `string` | `"ubuntu@24.04"` | no |
| <a name="input_k8s_channel"></a> [k8s\_channel](#input\_k8s\_channel) | The channel of the k8s charm | `string` | `"1.32/stable"` | no |
| <a name="input_k8s_config"></a> [k8s\_config](#input\_k8s\_config) | The juju config for k8s units | `map(string)` | `{}` | no |
| <a name="input_k8s_constraints"></a> [k8s\_constraints](#input\_k8s\_constraints) | The juju constraints for k8s units | `string` | `"arch=amd64 cores=2 mem=4096M root-disk=20480M virt-type=virtual-machine"` | no |
| <a name="input_k8s_units"></a> [k8s\_units](#input\_k8s\_units) | Number of units for k8s control plane | `number` | `1` | no |
| <a name="input_k8s_worker_base"></a> [k8s\_worker\_base](#input\_k8s\_worker\_base) | The base of the k8w worker charm | `string` | `"ubuntu@24.04"` | no |
| <a name="input_k8s_worker_channel"></a> [k8s\_worker\_channel](#input\_k8s\_worker\_channel) | The channel of the k8w worker charm | `string` | `"1.32/stable"` | no |
| <a name="input_k8s_worker_config"></a> [k8s\_worker\_config](#input\_k8s\_worker\_config) | The juju config for k8w worker units | `map(string)` | `{}` | no |
| <a name="input_k8s_worker_constraints"></a> [k8s\_worker\_constraints](#input\_k8s\_worker\_constraints) | The juju constraints for k8w worker units | `string` | `"arch=amd64 cores=2 mem=4096M root-disk=40960M virt-type=virtual-machine"` | no |
| <a name="input_k8s_worker_units"></a> [k8s\_worker\_units](#input\_k8s\_worker\_units) | Number of units for k8s data plane | `number` | `2` | no |

### Outputs

No outputs.
<!-- END_TF_DOCS -->


[juju]: https://juju.is/
[lxd]: https://documentation.ubuntu.com/lxd/en/latest/
[juju-docs]: https://canonical-juju.readthedocs-hosted.com/en/latest/user/reference/cloud/list-of-supported-clouds/the-lxd-cloud-and-juju/#the-lxd-cloud-and-juju
