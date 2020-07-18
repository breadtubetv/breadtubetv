#!/bin/bash

set -e

rm /app/tmp/pids/server.pid || true

bundle config --local with 'development test' && bundle install

exec "$@"