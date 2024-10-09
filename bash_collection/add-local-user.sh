#!/bin/bash

# Make sure the script is being executed with superuser privileges.
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root" 1>&2
    exit 1
fi

# Get the username (login).
read -p "Enter username: " USERNAME

# Get the real name (contents for the description field).
read -p "Enter full name (description): " FULL_NAME

# Get the password.
read -sp "Enter password: " password
echo

# Create the user with the password.
useradd -c "$FULL_NAME" -m "$USERNAME"
if [[ $? -ne 0 ]]; then
    echo "User creation failed." 1>&2
    exit 1
fi

# Set the password.
echo "$USERNAME:$password" | chpasswd
if [[ $? -ne 0 ]]; then
    echo "Setting password failed." 1>&2
    exit 1
fi

# Force password change on first login.
chage -d 0 "$USERNAME"

# Display the username, password, and the host where the user was created.
hostname=$(HOSTNAME)
echo "User created successfully!"
echo "Username: $USERNAME"
echo "Password: $password"
echo "Host: $HOSTNAME"
