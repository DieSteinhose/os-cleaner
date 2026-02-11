# OS Cleaner
Simple Linux cleanup script with a cronjob.

## Install
Run as root:

```bash
curl -fsSL https://raw.githubusercontent.com/DieSteinhose/os-cleaner/main/install.sh | sudo bash
```

## What it does
- Installs the cleanup script and makes it executable.
- Adds a cronjob to run weekly.
- Logs output to /var/log/os-cleaner.log.
- Reminds you if logrotate is not installed or active.

## Cleanup script details
- If Docker is installed, removes unused images and build cache.
- Cleans the apt cache.
- Removes unused dependencies and old kernels.
- Vacuums systemd journal logs older than 14 days.
- Prints a summary with the current free space on /.

## Manual run
```bash
sudo /usr/local/bin/os-cleaner
```