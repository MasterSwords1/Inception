#!/bin/bash
set -e

# Run redis in foreground
exec redis-server /etc/redis/redis.conf --daemonize no
