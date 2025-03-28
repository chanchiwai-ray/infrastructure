# 🚧 Ray's Development Infrastructure

This repository contains the terraform plans for my local software development. It's not used for continuous deployment,
but rather a way to quickly set up different infrastructures such as Kubernetes, Ceph, or OpenStack, for developing and
testing new features.

## 🌲 Repository structure

- [./shared](./shared) contains the hooks shared by different deployments.
- [./modules](./modules) contains the terraform modules for infrastructures.
- [./deployments](./deployments) contains the configurations for the deployment.
