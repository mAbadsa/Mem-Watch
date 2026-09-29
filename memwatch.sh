#!/bin/bash

THRESHOLD=85

# Get memory usage percentage
MEMORY_USAGE=$(free | awk '/^Mem:/ {printf("%.0f", ($3/$2)*100)}')

echo "Memory Usage: ${MEMORY_USAGE}%"

if (( MEMORY_USAGE > THRESHOLD )); then
  # Desktop notification (if available)
  if command -v notify-send &> /dev/null; then
    notify-send "Memory Alert" "Memory usage is ${MEMORY_USAGE}% (threshold: ${THRESHOLD}%)" -u critical
  fi

  # Log to file
  echo "$(date '+%Y-%m-%d %H:%M:%S') - ALERT: Memory usage ${MEMORY_USAGE}%" >> memory-alert.log

  # Optional: print to console
  echo "⚠️  ALERT: Memory usage ${MEMORY_USAGE}% exceeds threshold of ${THRESHOLD}%"
  exit 1
fi

exit 0
