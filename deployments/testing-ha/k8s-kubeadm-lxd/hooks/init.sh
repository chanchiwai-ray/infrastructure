#!/usr/bin/env bash

set -eou pipefail

KUBERNETES_VERSION="v1.35"  # see ../terragrunt.hcl
CRIO_VERSION="v1.35"  # match KUBERNETES_VERSION

nodes=($("$TG_CTX_TF_PATH" output -json | jq -r '.nodes.value | join(" ")'))

control_node="${nodes[0]}"
non_control_nodes="${nodes[@]:1}"

echo "Initializing k8s machines..."
echo "Initializing k8s control node..."
ssh ubuntu@$control_node -- "ssh-keygen -t rsa -b 2048 -N '' -f ~/.ssh/id_rsa -q <<< n > /dev/null 2>&1 || true && touch ~/.ssh/known_hosts"
echo "Initializing k8s control node... Done"

echo "Populating the public key of the control node to other nodes..."
control_node_name="$(ssh ubuntu@$control_node -- hostname)"
control_public_key="$(ssh ubuntu@$control_node -- 'cat ~/.ssh/id_rsa.pub')"
for node in $non_control_nodes; do
    ssh ubuntu@$node -- "sed -iE '/$control_node_name/d' ~/.ssh/authorized_keys && echo $control_public_key >> ~/.ssh/authorized_keys"
    ssh ubuntu@$control_node -- "ssh-keygen -R '$node' > /dev/null 2>&1 && ssh-keyscan -H '$node' >> ~/.ssh/known_hosts 2> /dev/null"
done
echo "Populating the public key of the control node to other nodes... Done"

echo "Installing necessary packages..."
for node in $control_node $non_control_nodes; do
    ssh ubuntu@$node -- "sudo apt-mark unhold cri-o kubelet kubeadm kubectl || true"
    ssh ubuntu@$node -- "sudo swapoff -a"
    ssh ubuntu@$node -- "sudo modprobe br_netfilter && sudo sysctl -w net.ipv4.ip_forward=1"
    ssh ubuntu@$node -- "sudo apt-get install -y apt-transport-https ca-certificates curl gpg"
    ssh ubuntu@$node -- "sudo rm -rf /etc/apt/keyrings/kubernetes-apt-keyring.gpg /etc/apt/sources.list.d/kubernetes.list /etc/apt/sources.list.d/cri-o.list"
    ssh ubuntu@$node -- "sudo mkdir -p -m 755 /etc/apt/keyrings && curl -fsSL https://pkgs.k8s.io/core:/stable:/$KUBERNETES_VERSION/deb/Release.key | sudo gpg --batch --yes --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg"
    ssh ubuntu@$node -- "echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/$KUBERNETES_VERSION/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list"
    ssh ubuntu@$node -- "curl -fsSL https://download.opensuse.org/repositories/isv:/cri-o:/stable:/$CRIO_VERSION/deb/Release.key | sudo gpg --batch --yes --dearmor -o /etc/apt/keyrings/cri-o-apt-keyring.gpg"
    ssh ubuntu@$node -- "echo 'deb [signed-by=/etc/apt/keyrings/cri-o-apt-keyring.gpg] https://download.opensuse.org/repositories/isv:/cri-o:/stable:/$CRIO_VERSION/deb/ /' | sudo tee /etc/apt/sources.list.d/cri-o.list"
    ssh ubuntu@$node -- "sudo apt-get update && sudo apt-get install -y cri-o kubelet kubeadm kubectl && sudo apt-mark hold cri-o kubelet kubeadm kubectl"
    ssh ubuntu@$node -- "sudo systemctl start crio.service"
done
echo "Installing necessary packages... Done"
echo
echo "Machines are initialized and ready for bootstraping!"
echo
