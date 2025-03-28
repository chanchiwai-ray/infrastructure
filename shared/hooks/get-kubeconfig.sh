#!/bin/bash

mkdir -p $HOME/.kube/

if [ -e $HOME/.kube/config ]; then
    mv $HOME/.kube/config $HOME/.kube/config.backup.$(date +%F)
fi

juju run k8s/0 get-kubeconfig | yq -r '.kubeconfig' >> $HOME/.kube/config
