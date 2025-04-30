#!/bin/bash

juju config k8s load-balancer-cidrs="$(juju status --format json | jq -r '[.machines[] | "\(."ip-addresses"[0])/32"] | join(" ")')"
