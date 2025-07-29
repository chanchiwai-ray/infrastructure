#!/usr/bin/env bash

set -eou pipefail

nodes=($("$TG_CTX_TF_PATH" output -json | jq -r '.nodes.value | join(" ")'))

leader_node="${nodes[0]}"
non_leader_nodes="${nodes[@]:1}"

echo "Bootstrapping microceph cluster..."
echo "Initializing microceph leader node..."
ssh ubuntu@$leader_node -- "sudo microceph cluster bootstrap"
ssh ubuntu@$leader_node -- "ssh-keygen -t rsa -b 2048 -N '' -f ~/.ssh/id_rsa -q <<< n > /dev/null 2>&1 || true && touch ~/.ssh/known_hosts"
echo "Initializing microceph leader node... Done"

echo "Populating the public key of the leader node to other nodes..."
leader_node_name="$(ssh ubuntu@$leader_node -- hostname)"
leader_public_key="$(ssh ubuntu@$leader_node -- 'cat ~/.ssh/id_rsa.pub')"
for node in $non_leader_nodes; do
    ssh ubuntu@$node -- "sed -iE '/$leader_node_name/d' ~/.ssh/authorized_keys && echo $leader_public_key >> ~/.ssh/authorized_keys"
    ssh ubuntu@$leader_node -- "ssh-keygen -R '$node' > /dev/null 2>&1 && ssh-keyscan -H '$node' >> ~/.ssh/known_hosts 2> /dev/null"
done
echo "Populating the public key of the leader node to other nodes... Done"

echo "Adding the non leader node to the cluster..."
for node in $non_leader_nodes; do
    fqdn="$(ssh ubuntu@$node -- 'hostname')"
    registration_key="$(ssh ubuntu@$leader_node -- 'sudo microceph cluster add '$fqdn'')"
    ssh ubuntu@$node -- "sudo microceph cluster join $registration_key"
done
echo "Adding the non leader node to the cluster... Done"

echo "Adding disks to all nodes..."
for node in $leader_node $non_leader_nodes; do
    ssh ubuntu@$node -- "sudo microceph disk add --all-available --wipe"
done
echo "Adding disks to all nodes... Done"
echo
echo "Bootstrap completed!"
echo
ssh ubuntu@$leader_node -- "sudo microceph status"
