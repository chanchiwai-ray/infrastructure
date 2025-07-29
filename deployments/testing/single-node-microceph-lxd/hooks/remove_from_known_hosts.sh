#!/usr/bin/env bash

set -eou pipefail

node=$("$TG_CTX_TF_PATH" output -raw node)

if [[ -z "$node" ]]; then
    exit 0
fi

ssh-keygen -R $node
echo "Removed $node from $HOME/.ssh/known_hosts"
