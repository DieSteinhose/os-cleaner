#!/bin/bash
set -e

INSTALL_PATH="/usr/local/bin/os-cleaner"
REPO_URL="https://raw.githubusercontent.com/diesteinhose/os-cleaner/main/os-cleaner.sh"
CRON_SCHEDULE="5 5 * * MON"

# Root-Check
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit 1
fi

# Download Script
curl -fsSL "$REPO_URL" -o "$INSTALL_PATH"
chmod +x "$INSTALL_PATH"

# Create cronjob erstellen
CRON_LINE="$CRON_SCHEDULE $INSTALL_PATH >> /var/log/os-cleaner.log 2>&1"
(crontab -l 2>/dev/null | grep -v "$INSTALL_PATH"; echo "$CRON_LINE") | crontab -

echo "Installation finished!"
echo "  Script: $INSTALL_PATH"
echo "  Cronjob: $CRON_SCHEDULE"
echo "  Log: /var/log/os-cleaner.log"

# Log rotation check (installed + active)
LOGROTATE_INSTALLED="false"
LOGROTATE_ACTIVE="false"

if command -v logrotate &>/dev/null; then
    LOGROTATE_INSTALLED="true"
fi

if command -v systemctl &>/dev/null; then
    if systemctl is-active --quiet logrotate.timer || systemctl is-active --quiet logrotate.service; then
        LOGROTATE_ACTIVE="true"
    fi
fi

if [ "$LOGROTATE_INSTALLED" = "true" ] && [ "$LOGROTATE_ACTIVE" = "true" ]; then
    echo "  Logrotate: installed and active"
else
    echo "  Reminder: logrotate is not installed or not active."
fi