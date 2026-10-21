# Linux System Monitor

A beginner Bash project that displays basic information about a Linux computer and saves each report to a log file.

## What it shows

- Date and computer name
- System load average
- Memory usage
- Disk space
- Disk warnings at or above a chosen threshold
- The five processes using the most CPU

**Note:** Load average is not the same as CPU usage percentage.

## Requirements

- Linux
- Bash
- The `uptime`, `free`, `df`, `awk`, `ps`, and `head` commands

## Run the script

From this project folder, make the script executable:

```bash
chmod +x scripts/monitor.sh
