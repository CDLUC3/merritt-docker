#!/usr/bin/env bash
set -euo pipefail

# Ensure mail log exists and stream it to container stdout.
mkdir -p /var/log
touch /var/log/maillog
tail -n0 -F /var/log/maillog &

exec /usr/sbin/postfix -v start-fg
