#!/bin/bash

# Function to detect package manager
detect_package_manager() {
    if command -v apt &>/dev/null; then
        echo "apt (Debian, Ubuntu, etc.)"
        PACKAGE_MANAGER="apt"
    elif command -v yum &>/dev/null; then
        echo "yum (CentOS, RHEL, Fedora 21 and below)"
        PACKAGE_MANAGER="yum"
    elif command -v dnf &>/dev/null; then
        echo "dnf (Fedora 22 and above, CentOS 8, RHEL 8)"
        PACKAGE_MANAGER="dnf"
    elif command -v pacman &>/dev/null; then
        echo "pacman (Arch Linux, Manjaro)"
        PACKAGE_MANAGER="pacman"
    elif command -v zypper &>/dev/null; then
        echo "zypper (openSUSE)"
        PACKAGE_MANAGER="zypper"
    elif command -v snap &>/dev/null; then
        echo "snap (Universal package manager)"
        PACKAGE_MANAGER="snap"
    else
        echo "Unknown package manager"
        PACKAGE_MANAGER="unknown"
    fi
}

# Function to detect Linux distribution
detect_distro() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        echo "Distro: $NAME"
    elif [ -f /etc/lsb-release ]; then
        . /etc/lsb-release
        echo "Distro: $DISTRIB_ID $DISTRIB_RELEASE"
    elif [ -f /etc/debian_version ]; then
        echo "Distro: Debian-based (Debian, Ubuntu, etc.)"
    elif [ -f /etc/redhat-release ]; then
        echo "Distro: Red Hat-based (RHEL, CentOS, Fedora)"
    elif [ -f /etc/arch-release ]; then
        echo "Distro: Arch Linux"
    else
        echo "Distro: Unknown"
    fi
}

# Function to update packages based on detected package manager
update_packages() {
    # Ensure the package manager is detected first
    detect_package_manager
    
    case "$PACKAGE_MANAGER" in
        apt)
            echo "Updating packages with apt..."
            sudo apt update && sudo apt upgrade -y
            ;;
        yum)
            echo "Updating packages with yum..."
            sudo yum update -y
            ;;
        dnf)
            echo "Updating packages with dnf..."
            sudo dnf update -y
            ;;
        pacman)
            echo "Updating packages with pacman..."
            sudo pacman -Syu --noconfirm
            ;;
        zypper)
            echo "Updating packages with zypper..."
            sudo zypper update -y
            ;;
        snap)
            echo "Updating snap packages..."
            sudo snap refresh
            ;;
        *)
            echo "Unknown package manager or no supported package manager found."
            ;;
    esac
    read -p "Press any key to return to the menu..."
}

# Function to make a backup using either tar or rsync
backup_files() {
    echo "Would you like to use 'tar' or 'rsync' for backup?"
    read -p "Enter 'tar' or 'rsync': " backup_method

    # Ask for the directory to back up and the destination location
    read -p "Enter the directory you want to back up (e.g., /home/user): " source_dir
    read -p "Enter the destination for the backup (e.g., /backup/location): " destination_dir

    # Ensure the source directory exists
    if [ ! -d "$source_dir" ]; then
        echo "Error: Source directory does not exist."
        exit 1
    fi

    # Ensure the destination directory exists or create it
    if [ ! -d "$destination_dir" ]; then
        echo "Destination directory does not exist. Creating it..."
        mkdir -p "$destination_dir"
    fi

    case "$backup_method" in
        tar)
            echo "Backing up using tar..."
            tar -czvf "$destination_dir/backup_$(date +%F).tar.gz" -C "$source_dir" .
            echo "Backup completed using tar."
            ;;
        rsync)
            echo "Backing up using rsync..."
            rsync -av --delete "$source_dir/" "$destination_dir/"
            echo "Backup completed using rsync."
            ;;
        *)
            echo "Invalid option. Please choose either 'tar' or 'rsync'."
            exit 1
            ;;
    esac
    read -p "Press any key to return to the menu..."
}

# Function to list open ports and their associated service names
list_open_ports() {
    echo "Listing open ports with their associated services..."

    # Check if ss is available, otherwise fallback to netstat
    if command -v ss &>/dev/null; then
        ss -tuln | awk 'NR>1 {print $5 " " $1}' | while read port; do
            # Extract IP and Port
            ip_port=$(echo $port | awk '{print $1}')
            service=$(echo $port | awk '{print $2}')

            # Get the numeric port
            port_number=$(echo $ip_port | cut -d: -f2)

            # If the service is available, display the service name
            if [ -n "$service" ]; then
                echo "Port: $port_number, Service: $service"
            else
                # Fallback to get the service name by port number
                service_name=$(getent services "$port_number" | awk '{print $1}')
                echo "Port: $port_number, Service: ${service_name:-Unknown}"
            fi
        done
    else
        echo "'ss' command not found. Trying 'netstat'..."

        if command -v netstat &>/dev/null; then
            netstat -tuln | awk 'NR>2 {print $4}' | cut -d: -f2 | while read port; do
                service_name=$(getent services "$port" | awk '{print $1}')
                echo "Port: $port, Service: ${service_name:-Unknown}"
            done
        else
            echo "Neither 'ss' nor 'netstat' commands are available."
        fi
    fi
    read -p "Press any key to return to the menu..."
}

# Function to monitor storage performance
monitor_storage() {
    echo "Monitoring storage performance..."

    # Check if iostat is installed (iostat is part of sysstat package)
    if command -v iostat &>/dev/null; then
        echo "Disk I/O stats (iostat):"
        iostat -x 1 5
    else
        echo "'iostat' not found. Please install sysstat to monitor disk I/O performance."
    fi

    # Check for disk usage stats (df)
    echo "Disk Usage Stats (df):"
    df -h

    # Check if dstat is installed (for real-time monitoring)
    if command -v dstat &>/dev/null; then
        echo "Real-time Disk Stats (dstat):"
        dstat -d --disk-util --disk-avg-queue --disk-io
    else
        echo "'dstat' not found. You can install it for real-time disk stats."
    fi
    read -p "Press any key to return to the menu..."
}

# Function to check SSL certificate for a domain
check_ssl_certificate() {
    read -p "Enter the domain to check SSL certificate (e.g., example.com): " domain

    # Retrieve the SSL certificate using openssl s_client
    echo "Checking SSL certificate for $domain..."

    # Check if openssl is installed
    if command -v openssl &>/dev/null; then
        # Fetch the certificate details
        cert_info=$(echo | openssl s_client -connect "$domain:443" -servername "$domain" 2>/dev/null | openssl x509 -noout -dates)
        
        if [ -z "$cert_info" ]; then
            echo "Could not retrieve certificate for $domain. Make sure the domain has an SSL certificate installed."
            return 1
        fi

        # Parse expiration date from the certificate
        expiration_date=$(echo "$cert_info" | grep 'notAfter' | sed 's/^.*notAfter=//')

        # Display expiration date
        echo "SSL Certificate Expiration Date for $domain: $expiration_date"

        # Check if certificate is self-signed
        cert_issuer=$(echo | openssl s_client -connect "$domain:443" -servername "$domain" 2>/dev/null | openssl x509 -noout -issuer)
        if echo "$cert_issuer" | grep -q "CN=*.${domain}"; then
            echo "Warning: The certificate is self-signed."
        else
            echo "The certificate is issued by a recognized Certificate Authority."
        fi
    else
        echo "openssl command not found. Please install OpenSSL to check the SSL certificate."
    fi
    read -p "Press any key to return to the menu..."
}

# Display Menu for User
menu() {
    clear
    echo "==============================="
    echo " Linux System Utility Script"
    echo "==============================="
    echo "1. Detect Linux Distribution and Package Manager"
    echo "2. Update System Packages"
    echo "3. Backup Files (tar or rsync)"
    echo "4. List Open Ports"
    echo "5. Monitor Storage Performance"
    echo "6. Check SSL Certificate"
    echo "7. Exit"
    echo "==============================="
    read -p "Choose an option [1-7]: " option
    case $option in
        1) detect_distro ;;
        2) update_packages ;;
        3) backup_files ;;
        4) list_open_ports ;;
        5) monitor_storage ;;
        6) check_ssl_certificate ;;
        7) echo "Exiting..."; exit 0 ;;
        *) echo "Invalid option. Please choose a number between 1 and 7."; menu ;;
    esac
}

# Main loop to display the menu
while true; do
    menu
done

