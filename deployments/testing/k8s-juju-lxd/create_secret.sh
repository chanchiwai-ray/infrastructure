#!/bin/bash

# Create a secret for the registry authentication
kubectl create secret generic registry-auth --from-literal="htpasswd=$(pwgen -n 16 -c -1 -y)" -n docker-registry

openssl req -x509 -newkey rsa:4096 -sha256 -days 365 -nodes \
  -keyout tls.key -out tls.crt \
  -subj "/CN=docker-registry.local" \
  -addext "subjectAltName=DNS:docker-registry.local"

kubectl create secret tls registry-tls-secret \
  --cert=tls.crt \
  --key=tls.key \
  -n docker-registry
