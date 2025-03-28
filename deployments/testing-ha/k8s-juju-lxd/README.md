# Three nodes Kubernetes Deployment

This terragrunt unit deploy three nodes Kubernetes using Canoincal Kubernetes. This includes one control plane and three
worker nodes (the control plane served also as a worker node).

## Example Deployment Status

**Juju status:**

```text
$ juju status
Model  Controller  Cloud/Region         Version  SLA          Timestamp
k8s    overlord    localhost/localhost  3.6.3    unsupported  16:45:37+08:00

App         Version  Status  Scale  Charm       Channel      Rev  Exposed  Message
k8s         1.32.2   active      1  k8s         1.32/stable  458  yes      Ready
k8s-worker  1.32.2   active      2  k8s-worker  1.32/stable  456  no       Ready

Unit           Workload  Agent  Machine  Public address  Ports     Message
k8s-worker/0*  active    idle   0        10.42.75.89               Ready
k8s-worker/1   active    idle   1        10.42.75.137              Ready
k8s/0*         active    idle   2        10.42.75.195    6443/tcp  Ready

Machine  State    Address       Inst id        Base          AZ  Message
0        started  10.42.75.89   juju-51b062-0  ubuntu@24.04      Running
1        started  10.42.75.137  juju-51b062-1  ubuntu@24.04      Running
2        started  10.42.75.195  juju-51b062-2  ubuntu@24.04      Running
```

**Kubernetes nodes:**

```text
$ kubectl get nodes
NAME            STATUS   ROLES                  AGE   VERSION
juju-51b062-0   Ready    worker                 11m   v1.32.2
juju-51b062-1   Ready    worker                 11m   v1.32.2
juju-51b062-2   Ready    control-plane,worker   12m   v1.32.2
```

