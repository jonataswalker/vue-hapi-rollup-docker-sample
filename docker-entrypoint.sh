#!/bin/sh
set -e

START_FILE=/www/$(sed -nE 's/^\s*"main": "(.*?)",$/\1/p' /www/package.json)

if [ "${NODE_ENV}" = "development" ]; then
  cp -r /tmp/node_modules /www
  exec pm2-dev $START_FILE --node-args="--inspect=0.0.0.0:7000"
else
  exec pm2-runtime $START_FILE
fi

exec "$@"
