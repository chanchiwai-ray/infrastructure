# Development environment for MicroCeph cluster

## Quickstart

```shell
terragrunt apply
```

## Development with local MicroCeph

Set up development environment (snap try):

```shell
just dev
```

Build microceph locally and update the binaries:

```shell
# In microceph repo, build microceph and microcephd. Also see
# https://github.com/canonical/microceph/blob/main/HACKING.md#-unit-testing for how to build MicroCeph
git clone git@github.com:canonical/microceph.git
cd microceph/microceph && make build

# update the microceph and microcephd binary in-place
just microceph=$(which microceph) microcephd=$(which microcephd) update
```

Clean up the development environment (snap try):

```shell
just clean
```

Clean up the whole development environment:

```shell
terragrunt apply --destroy
```
