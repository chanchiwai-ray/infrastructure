export BACKEND := env_var_or_default("BACKEND", "terraform")

[private]
default:
    @echo
    @just --list -u

# List available deployments
[group("main")]
list:
    @echo
    @terragrunt list -l
    @echo
    @echo Tips: use \`just show DEPLOYMENT_NAME\` to see details of a deployment

# Show details of a deployment
[group("main")]
show deployment:
    @echo
    @cd "{{ deployment }}" && terragrunt show

# Plan a deployment, optionally overriding cpu/mem/disk/num
[group("main")]
plan deployment cpu="" mem="" disk="" num="":
    #!/usr/bin/env bash
    set -euo pipefail
    args=()
    [ -n "{{ cpu }}" ] && args+=(-var "cpu={{ cpu }}")
    [ -n "{{ mem }}" ] && args+=(-var "memory={{ mem }}")
    [ -n "{{ disk }}" ] && args+=(-var "disks={{ disk }}")
    [ -n "{{ num }}" ] && args+=(-var "num={{ num }}")
    cd "{{ deployment }}" && terragrunt plan "${args[@]}"

# Apply a deployment, optionally overriding cpu/mem/disk/num
[group("main")]
apply deployment cpu="" mem="" disk="" num="":
    #!/usr/bin/env bash
    set -euo pipefail
    args=()
    [ -n "{{ cpu }}" ] && args+=(-var "cpu={{ cpu }}")
    [ -n "{{ mem }}" ] && args+=(-var "memory={{ mem }}")
    [ -n "{{ disk }}" ] && args+=(-var "disks={{ disk }}")
    [ -n "{{ num }}" ] && args+=(-var "num={{ num }}")
    cd "{{ deployment }}" && terragrunt apply "${args[@]}"

# Destroy a deployment
[group("main")]
destroy deployment:
    #!/usr/bin/env bash
    set -euo pipefail
    cd "{{ deployment }}" && terragrunt destroy "${args[@]}"

# Format all terragrunt / terraform files
[group("development")]
fmt:
    @echo
    @terragrunt hcl fmt
    @${BACKEND} fmt -recursive

# Validate all terragrunt / terraform files
[group("development")]
lint:
    @echo
    @terragrunt hcl fmt -check
    @${BACKEND} fmt -check -recursive

# Remove all .terragrunt-cache directories in all deployments
[group("development")]
clean:
    @echo
    @find . -type d -name ".terragrunt-cache" -prune -exec rm -rf {} +
