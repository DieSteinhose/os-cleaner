#!/bin/bash

# Docker Cleanup if installed
if command -v docker &>/dev/null; then

    # Remove unused Docker Images
    docker image prune -a -f

    # Cleanup Docker Build-Cache
    docker builder prune -a -f 
fi

# Clean up apt cache
apt-get clean -y

# Remove Unused Dependencies & old Kernels
apt-get autoremove --purge -y

# Logs (older than 7 days)
journalctl --vacuum-time=7d

# Finish
sync
echo "[$(date)] Cleanup done. Free Storage: $(df -h / | awk 'NR==2 {print $4}')"