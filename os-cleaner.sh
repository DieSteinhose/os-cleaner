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

DELTA_DISPLAY=$(awk -v kb="$DELTA_KB" 'BEGIN{b=kb*1024;split("B KB MB GB TB",u," ");i=1;while(b>=1024&&i<5){b/=1024;i++}printf ((b==int(b))?"%d%s":"%.1f%s"),b,u[i]}')

echo "[$(date)] Cleanup done. Free Storage: $(df -h / | awk 'NR==2 {print $4}') (space recovered: ${DELTA_DISPLAY})"