#!/bin/bash

THRESHOLD=${THRESHOLD:-85}
COOLDOWN=${COOLDOWN:-300}  # 5 minutes in seconds
ALERT_FILE=".memwatch-alert-time"

# Get memory usage percentage
MEMORY_USAGE=$(free | awk '/^Mem:/ {printf("%.0f", ($3/$2)*100)}')

echo "Memory Usage: ${MEMORY_USAGE}%"

if (( MEMORY_USAGE > THRESHOLD )); then
  # Check if enough time has passed since last alert
  CURRENT_TIME=$(date +%s)
  LAST_ALERT=$(cat "$ALERT_FILE" 2>/dev/null || echo 0)
  TIME_SINCE_ALERT=$((CURRENT_TIME - LAST_ALERT))

  # Always log
  echo "$(date '+%Y-%m-%d %H:%M:%S') - ALERT: Memory usage ${MEMORY_USAGE}%" >> memory-alert.log

  # Notify only if cooldown passed
  if (( TIME_SINCE_ALERT >= COOLDOWN )); then
    # Desktop notification (if available)
    if command -v notify-send &> /dev/null; then
      notify-send "Memory Alert" "Memory usage is ${MEMORY_USAGE}% (threshold: ${THRESHOLD}%)" -u critical
    fi

    # Print alert to console
    echo "⚠️  ALERT: Memory usage ${MEMORY_USAGE}% exceeds threshold of ${THRESHOLD}%"

    # Show top 5 memory consumers
    echo ""
    echo "Top 5 memory consumers:"
    ps aux --sort=-%mem | head -6 | tail -5 | awk '{printf "  %s (PID %s): %.1f%%\n", $11, $2, $4}'

    # Update alert timestamp
    echo "$CURRENT_TIME" > "$ALERT_FILE"
  else
    MINS_LEFT=$((($COOLDOWN - $TIME_SINCE_ALERT) / 60))
    echo "  (notification suppressed, cooldown in ${MINS_LEFT}m)"
  fi

  exit 1
fi

exit 0
