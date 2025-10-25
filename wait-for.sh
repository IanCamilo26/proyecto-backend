#!/usr/bin/env sh
set -e
hostport="$1"; shift
if [ -z "$hostport" ]; then
  echo "Usage: $0 host:port -- command"
  exit 1
fi
# si el primer token es -- lo saltamos
if [ "$1" = "--" ]; then
  shift
fi
host=$(echo "$hostport" | cut -d: -f1)
port=$(echo "$hostport" | cut -d: -f2)
echo "Waiting for $host:$port..."
while ! nc -z "$host" "$port" 2>/dev/null; do
  sleep 1
done
echo "$host:$port is available"
exec "$@"