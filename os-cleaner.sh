#!/bin/bash

# Track free space before cleanup (in KB)
FREE_BEFORE_KB=$(df -kP / | awk 'NR==2 {print $4}')

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
journalctl --vacuum-time=14d

# Finish
sync
FREE_AFTER_KB=$(df -kP / | awk 'NR==2 {print $4}')
DELTA_KB=$((FREE_AFTER_KB - FREE_BEFORE_KB))
if [ "$DELTA_KB" -lt 0 ]; then
    DELTA_KB=0
fi

if command -v numfmt &>/dev/null; then
    DELTA_DISPLAY=$(numfmt --to=iec --suffix=B -- $((DELTA_KB * 1024)))
else
    DELTA_DISPLAY="${DELTA_KB}K"
fi

echo "[$(date)] Cleanup done. Free Storage: $(df -h / | awk 'NR==2 {print $4}') (space recovered: ${DELTA_DISPLAY})"