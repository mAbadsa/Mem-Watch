# MemWatch

A lightweight bash script that monitors system memory usage and sends alerts when it exceeds a configurable threshold.

## Features

- **Real-time monitoring** — Check current memory usage instantly
- **Desktop notifications** — Visual alerts via `notify-send` (Linux)
- **Alert logging** — Tracks all alerts in `memory-alert.log`
- **Configurable threshold** — Default 85%, easily customizable
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

Edit the script to adjust the threshold:
```bash
THRESHOLD=85  # Alert when memory exceeds 85%
```

## Output

- Prints current memory percentage to console
- Sends desktop notification (if above threshold)
- Logs timestamp and alert to `memory-alert.log`
- Exit code 1 if alert triggered, 0 otherwise

## Requirements

- `bash` and standard utilities (`free`, `awk`)
- `notify-send` (optional, for desktop notifications)

## Example

```
$ ./memwatch.sh
Memory Usage: 73%

$ ./memwatch.sh  # With threshold lowered to 50%
Memory Usage: 64%
⚠️  ALERT: Memory usage 64% exceeds threshold of 50%
```
