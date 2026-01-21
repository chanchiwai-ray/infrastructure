# Deploy Kubernetes cluster using kubeadm

This terragrunt module set up LXD VMs ready for bootstrapping a Kubernetes cluster using kubeadm. The VMs will be
configured to have necessary packages (`kubeadm`, `kubectl`, ...) to begin with.

## Quickstart

```shell
terragrunt apply  # deploy the VMs
terragrunt output  # get the IP addresses for the VMs
```

## Exercise 1: Create the control plane node

1. Create the k8s control plane using `kubeadm` in `k8s-0`.
2. Install a container network interface (CNI), such as `cilium`, to make the all the pods happy.

References:
- https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/
- https://docs.cilium.io/en/stable/installation/k8s-install-helm/

## Exercise 2: Add a worker node

1. Add a worker node (`k8s-1`) to the k8s cluster.
2. Label and taint the nodes appropriately if not already done so.
  * The worker node should not have any taints.
  * The worker node should have a role of `worker`.


## Exercise 3: Upgrade the control plane and worker node

1. Upgrade the control plane node
2. Upgrade the worker node

## Exercise 4: Install a container storage interface

1. Install container storage interface (CSI), such as `rawfile-localpv`

## Exercise 5: Install a loadbalancer, ingress controller, and / or a gateway controller

1. Install a loadbalancer
2. Install an ingress controller
3. Install a gateway controller (typically provided also by CNI)

Tips:

1. kubectl apply -f ippool.yaml

```yaml
# ippool.yaml
apiVersion: "cilium.io/v2"
kind: CiliumLoadBalancerIPPool
metadata:
  name: "blue-pool"
spec:
  blocks:
  - cidr: "10.8.0.0/24"
```

References:
- https://docs.cilium.io/en/stable/network/lb-ipam/
- https://docs.cilium.io/en/stable/network/servicemesh/gateway-api/gateway-api/

## Clean up

```shell
terragrunt apply --destroy
```
