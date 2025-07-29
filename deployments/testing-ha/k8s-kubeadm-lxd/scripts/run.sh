#!/bin/bash

# Function to print error messages and exit
function error_exit {
    echo -e "\033[31mError: $1\033[0m" >&2
    exit 1
}

# Function to print success messages
function success_message {
    echo -e "\033[32m$1\033[0m"
}

# Function to print info messages
function info_message {
    echo -e "\033[34m$1\033[0m"
}

# Function to print usage/help message
function print_usage {
    cat <<EOF
Usage: $(basename "$0") [OPTIONS]

Options:
  --local-file                Specify the local file path to sync with rsync.
  --remote-file               Specify the remote file path for rsync.
  --dev                       Run snap download, unsquashfs, and snap try commands for MicroCeph on remote servers.
  --update                    Update snap try files
  --clean                     Clean up snap try setup for MicroCeph on remote servers.
  --user                      Specify the remote user for rsync or remote commands (default: ubuntu).
  --help, -h                  Display this help message.

Example:
  ./$(basename "$0") --dev
  ./$(basename "$0") --clean
EOF
    exit 0
}

# Function to fetch server IPs matching the criteria silently
function fetch_server_ips {
    echo $(terragrunt output -json | jq -r '.nodes.value | join(" ")')
}

function dev {
    local ips="$1"
    local user="$2"

    info_message "Running snap download, unsquashfs, and snap try commands for MicroCeph on remote servers as user '$user'..."

    for ip in $ips; do
        info_message "Setting up snap try for MicroCeph on $ip..."
        ssh "$user@$ip" "rm -rf /home/$user/squashfs-root-microceph && \
            sudo snap download microceph --basename microceph && \
            sudo unsquashfs -d /home/$user/squashfs-root-microceph ~/microceph.snap && \
            sudo chmod -R u+rw /home/$user/squashfs-root-microceph && \
            sudo chown -R $user:$user /home/$user/squashfs-root-microceph && \
            sudo snap try /home/$user/squashfs-root-microceph" || \
            error_exit "Failed to setup snap try for MicroCeph on $ip."
        success_message "Successfully set up snap try for MicroCeph on $ip."
    done
}

function update {
    local local_path="$1"
    local remote_path="$2"
    local ips="$3"
    local user="$4"

    info_message "Starting rsync of single file '$local_path' to '$remote_path' on remote servers as user '$user'..."

    for ip in $ips; do
        info_message "Rsyncing to $ip..."
        if ! rsync -avz "$local_path" "$user@$ip:$remote_path"; then
            error_exit "Failed to rsync file '$local_path' to $ip:$remote_path."
        fi
        success_message "Successfully synced to $ip:$remote_path."
    done
}

function clean {
    local ips="$1"
    local user="$2"

    info_message "Cleaning snap try setup for MicroCeph on remote servers as user '$user'..."

    for ip in $ips; do
        info_message "Cleaning snap try for MicroCeph on $ip..."
        if ! ssh "$user@$ip" "sudo snap refresh microceph --amend && sudo rm -rf /home/$user/squashfs-root-microceph"; then
            error_exit "Failed to clean snap try for MicroCeph on $ip."
        fi
        success_message "Successfully cleaned snap try for MicroCeph on $ip."
    done
}

# Main script execution
function main {
    local user="ubuntu"
    local dev_flag=false
    local update_flag=false
    local clean_flag=false
    local local_file=""
    local remote_file=""

    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --update)
                update_flag=true
                shift
                ;;
            --local-file)
                local_file="$2"
                shift 2
                ;;
            --remote-file)
                remote_file="$2"
                shift 2
                ;;
            --dev)
                dev_flag=true
                shift
                ;;
            --clean)
                clean_flag=true
                shift
                ;;
            --user)
                user="$2"
                shift 2
                ;;
            --help|-h)
                print_usage
                ;;
            *)
                error_exit "Unknown option: $1"
                ;;
        esac
    done

    # Fetch server IPs
    server_ips=$(fetch_server_ips)
    info_message server_ips

    if [ -z "$server_ips" ]; then
        error_exit "No IP addresses found for servers, have you run `terragrunt apply`?"
    fi

    # Optional rsync execution
    if [ "$update_flag" == "true" ]; then
        if [ -z "$local_file" ] || [ -z "$remote_file" ]; then
            error_exit "--update requires both --local-file and --remote-file to be specified."
        fi
        update "$local_file" "$remote_file" "$server_ips" "$user"
    fi

    # Optional setup snap try for MicroCeph execution
    if [ "$dev_flag" == "true" ]; then
        dev "$server_ips" "$user"
    fi

    # Optional clean snap try for MicroCeph execution
    if [ "$clean_flag" == "true" ]; then
        clean "$server_ips" "$user"
    fi
}

# Run the main function
main "$@"
