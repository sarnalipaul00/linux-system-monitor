#!/usr/bin/env bash
DISK_WARN_PERCENT="${DISK_WARN_PERCENT:-80}"
LOG_FILE="${LOG_FILE:-$HOME/linux-system-monitor.log}"

if ! [[ "$DISK_WARN_PERCENT" =~ ^[0-9]+$ ]] || (( DISK_WARN_PERCENT < 1 || DISK_WARN_PERCENT > 100 )); then
  echo "ERROR: DISK_WARN_PERCENT must be a number from 1 to 100." >&2
  exit 2
fi

timestamp="$(date --iso-8601=seconds)"

{
  echo "========================================"
  echo "Linux System Report"
  echo "Time: $timestamp"
  echo "Host: $(hostname)"
  echo

  echo "Load average:"
  uptime
  echo

  echo "Memory:"
  free -h
  echo

  echo "Disk space:"
  df -h
  echo

  echo "Disk warnings (threshold: ${DISK_WARN_PERCENT}%):"
  df -P | awk -v limit="$DISK_WARN_PERCENT" '
    NR > 1 {
       usage = $5
       gsub(/%/, "", usage)
       if (usage >= limit) {
          print "WARNING:", $6, "is", usage "% full"
          found = 1
    }
  }
  END {
    if (!found) print "No filesystems are at or above " limit "%"
  }
  '
  echo

  echo "Top 5 processes by CPU:"
  ps -eo pid,comm,%cpu,%mem --sort=-%cpu | head -n 6
} | tee -a "$LOG_FILE"
