#!/bin/bash

THRESHOLD=${THRESHOLD:-85}

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

  # Print alert to console
  echo "⚠️  ALERT: Memory usage ${MEMORY_USAGE}% exceeds threshold of ${THRESHOLD}%"

  # Show top 5 memory consumers
  echo ""
  echo "Top 5 memory consumers:"
  ps aux --sort=-%mem | head -6 | tail -5 | awk '{printf "  %s (PID %s): %.1f%%\n", $11, $2, $4}'

  exit 1
fi

exit 0
