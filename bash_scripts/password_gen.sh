#!/bin/bash

# Generate a random password
PASSWORD=$(tr -dc 'A-Za-z0-9@#$%^&*()_+[]{}|;:,.<>?' < /dev/urandom | fold -w 10 | head -n 1)

# Save the password to a file
echo "$PASSWORD" > password.txt

echo "Generated Password: $PASSWORD"
echo "Password saved to password.txt"

