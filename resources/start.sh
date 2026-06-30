#!/bin/bash
set -e

# Gunicorn web-tier launcher for the nirmaan_stack image.
#
# Worker/thread/timeout counts are read from the environment so they can be
# tuned at deploy time (compose env / .env) WITHOUT rebuilding the image.
#
# Defaults are tuned for an all-in-one 2 vCPU / 8 GB host where Postgres,
# Redis, the RQ workers and the scheduler share the box. Keep
# (workers x threads) comfortably under Postgres `max_connections` (default 100).
GUNICORN_WORKERS=${GUNICORN_WORKERS:-3}
GUNICORN_THREADS=${GUNICORN_THREADS:-4}
GUNICORN_TIMEOUT=${GUNICORN_TIMEOUT:-120}

echo "Booting Gunicorn with ${GUNICORN_WORKERS} workers / ${GUNICORN_THREADS} threads (timeout ${GUNICORN_TIMEOUT}s)..."

exec /home/frappe/frappe-bench/env/bin/gunicorn \
  --chdir=/home/frappe/frappe-bench/sites \
  --bind=0.0.0.0:8000 \
  --threads="$GUNICORN_THREADS" \
  --workers="$GUNICORN_WORKERS" \
  --worker-class=gthread \
  --worker-tmp-dir=/dev/shm \
  --timeout="$GUNICORN_TIMEOUT" \
  --preload \
  frappe.app:application
