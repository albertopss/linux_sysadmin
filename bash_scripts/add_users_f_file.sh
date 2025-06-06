#!/bin/bash

# Usage check
if [ $# -ne 2 ]; then
    echo "Usage: $0 <user_list_file> <group_name>"
    exit 1
fi

USERLIST="$1"
GROUP="$2"

# Check if group exists, if not create it
if ! getent group "$GROUP" > /dev/null; then
    echo "❌ Group '$GROUP' does not exist. Creating it..."
    sudo groupadd "$GROUP"
fi

# Loop through each user in the file
while IFS= read -r USER; do
    # Skip empty lines or comments
    [[ -z "$USER" || "$USER" =~ ^# ]] && continue

    # Create user if they don't exist
    if ! id "$USER" &>/dev/null; then
        echo "➕ Creating user '$USER'..."
        sudo useradd "$USER"
        # Optional: set a default password (not secure for production!)
        echo "$USER:password" | sudo chpasswd
    fi

    # Add user to the group
    sudo usermod -aG "$GROUP" "$USER"
    echo "✅ User '$USER' added to group '$GROUP'."

done < "$USERLIST"
