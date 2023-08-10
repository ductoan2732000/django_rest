#!/bin/sh
set -e

if [ $ENV != PROD ]
then echo "Waiting for database..."
  wait-for mysql:3306 -t 60 -- echo "Done"
fi

exec "$@"
