#!/bin/bash

# === Configuration ===
BACKUP_DIR="/mnt/LVM1"
DATE=$(date +%F)
HOSTNAME=$(hostname)
BACKUP_NAME="${HOSTNAME}_fullbackup_${DATE}.tar.gz"
EXCLUDES=(
    --exclude=/proc
    --exclude=/tmp
    --exclude=/mnt
    --exclude=/dev
    --exclude=/sys
    --exclude=/run
    --exclude=/media
    --exclude=${BACKUP_DIR}
)

# === Make sure backup directory exists ===
mkdir -p "$BACKUP_DIR"

# === Create the backup ===
echo "Starting backup: $BACKUP_NAME"
tar -cvpzf "${BACKUP_DIR}/${BACKUP_NAME}" "${EXCLUDES[@]}" /
echo "Backup completed successfully: ${BACKUP_DIR}/${BACKUP_NAME}"

