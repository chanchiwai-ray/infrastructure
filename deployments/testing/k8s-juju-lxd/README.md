# Single node Kubernetes Deployment

This terragrunt unit deploys single node Kubernetes cluster using Canoincal Kubernetes. The node acts as a control
plane node and a worker node.

**Features enabled**

- Gateway
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

## Local Docker Registry

Run the following command to create the local docker registry:

```bash
kubectl apply -f docker-registry.yaml
./create_secret.sh
```

The docker registry is exposed by a gateway. Use the following command to get the gateway IP address:

```bash
GATEWAY_IP=$(kubectl -n docker-registry get gateway registry-gateway -o jsonpath='{.status.addresses[0].value}')
echo "Gateway IP: $GATEWAY_IP"
```

Note, you will also need to add an entry to your `/etc/hosts` file to map the gateway IP address to
`docker-registry.local`, and `sshuttle` to ensure that the traffic to `docker-registry.local` is routed through the
sshuttle tunnel:

```bash
echo "$GATEWAY_IP docker-registry.local" | sudo tee -a /etc/hosts
sshuttle -r ubuntu@<K8S_NODE_IP> $GATEWAY_IP  # the K8S_NODE_IP can be found in the lxc list or juju status output
```

The docker registry will be available at `docker-registry.local:5000`. To test the if the docker registry is running, you
can try listing the catalog with `curl`:

```bash
curl http://docker-registry.local/v2/_catalog
```

and it should return something like this:

```json
{"repositories":[]}
```

And now you can push your local OCI-compatible images to the docker registry.

Finally, for you k8s cluster to pull images from the docker registry, you will still need to let the container runtime
(containerd) know about the registry. You need to do it in the **k8s node**.

```yaml
lxc shell <k8s_node_name>  # the k8s_node_name can be found in the lxc list
```

Then edit the containerd configuration file `/etc/containerd/config.toml` and add the following registry configuration:

```toml
[plugins."io.containerd.grpc.v1.cri".registry]
  config_path = "/etc/containerd/certs.d"
```

Then create the directory for the registry and add the registry configuration:

```bash
sudo mkdir -p /etc/containerd/certs.d/docker-registry.local
cat > /etc/containerd/certs.d/docker-registry.local/hosts.toml <<EOF
server = "http://docker-registry.local"

[host."http://docker-registry.local"]
  capabilities = ["pull", "resolve"]
EOF
```

Lastly, add the entry to the `/etc/hosts` file in the k8s node to map the gateway IP address to `docker-registry.local`
and restart the containerd service:

```bash
echo "$GATEWAY_IP docker-registry.local" | sudo tee -a /etc/hosts
snap restart k8s.containerd
```
