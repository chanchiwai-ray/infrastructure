#!/usr/bin/env bash

set -eou pipefail

nodes="$("$TG_CTX_TF_PATH" output -json | jq -r '.nodes.value | join(" ")')"

if [[ -z "$nodes" ]]; then
    exit 0
fi

for node in $nodes; do
    ssh-keygen -R "$node"
    echo "Removed $node from $HOME/.ssh/known_hosts"
done
