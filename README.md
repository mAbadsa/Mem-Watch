# MemWatch

A lightweight bash script that monitors system memory usage and sends alerts when it exceeds a configurable threshold.

## Features

- **Real-time monitoring** — Check current memory usage instantly
- **Desktop notifications** — Visual alerts via `notify-send` (Linux)
- **Alert logging** — Tracks all alerts in `memory-alert.log`
- **Configurable threshold** — Set via `THRESHOLD` env var (default 85%)
- **Alert cooldown** — Prevent notification spam (default 5 min, configurable)
- **Top memory consumers** — Shows top 5 processes when alert triggers
- **Exit codes** — Returns 1 on alert, 0 on success (useful for scripts/cron)

## Usage

### One-time check
```bash
./memwatch.sh
```

### Continuous monitoring (every 60 seconds)
```bash
watch -n 60 ./memwatch.sh
```

### Automated with cron (check every 5 minutes)
```bash
crontab -e
# Add this line:
*/5 * * * * /path/to/memwatch.sh
```

## Configuration

Use environment variables to customize behavior (no script editing needed):

```bash
# Set memory threshold (default: 85)
THRESHOLD=90 ./memwatch.sh

# Set alert cooldown in seconds (default: 300 = 5 minutes)
COOLDOWN=120 ./memwatch.sh

# Combine both
THRESHOLD=80 COOLDOWN=600 ./memwatch.sh
```

## Output

- Prints current memory percentage to console
- Sends desktop notification (if above threshold AND cooldown passed)
- Shows top 5 memory-consuming processes when alert triggers
- Logs timestamp and alert to `memory-alert.log` (every check, always)
- Shows notification status: active alert or suppressed with cooldown time remaining
- Exit code 1 if alert triggered, 0 otherwise

## Requirements

- `bash` and standard utilities (`free`, `awk`)
- `notify-send` (optional, for desktop notifications)

## Example

```
$ ./memwatch.sh
Memory Usage: 73%

$ THRESHOLD=50 ./memwatch.sh
Memory Usage: 64%
⚠️  ALERT: Memory usage 64% exceeds threshold of 50%

Top 5 memory consumers:
  /usr/lib/firefox/firefox (PID 3421): 12.5%
  /usr/bin/python3 (PID 2156): 8.3%
  /usr/bin/code (PID 1890): 6.7%
  /usr/sbin/systemd-resolved (PID 845): 0.8%
  /usr/bin/Xvfb (PID 1124): 0.5%

$ THRESHOLD=50 COOLDOWN=60 ./memwatch.sh  # Within cooldown window
Memory Usage: 65%
  (notification suppressed, cooldown in 4m)
```
