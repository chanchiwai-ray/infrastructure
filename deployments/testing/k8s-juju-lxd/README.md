# Single node Kubernetes Deployment

This terragrunt unit deploys single node Kubernetes cluster using Canoincal Kubernetes. The node acts as a control
plane node and a worker node.

**Features enabled**

- Ingress
- Loadbalancer
- Local storage

## Example Deployment Status

**Juju status:**

```text
$ juju status
Model  Controller  Cloud/Region         Version  SLA          Timestamp
k8s    overlord    localhost/localhost  3.6.3    unsupported  12:39:11+08:00

App  Version  Status  Scale  Charm  Channel      Rev  Exposed  Message
k8s  1.32.2   active      1  k8s    1.32/stable  458  yes      Ready

Unit    Workload  Agent  Machine  Public address  Ports     Message
k8s/0*  active    idle   0        10.42.75.126    6443/tcp  Ready

Machine  State    Address       Inst id        Base          AZ  Message
0        started  10.42.75.126  juju-3b73da-0  ubuntu@24.04      Running
```

**Kubernetes nodes:**

```text
$ kubectl get nodes
NAME            STATUS   ROLES                  AGE     VERSION
juju-3b73da-0   Ready    control-plane,worker   4m48s   v1.32.2
```
