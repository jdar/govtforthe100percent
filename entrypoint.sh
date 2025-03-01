#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f /refugeexperiences/tmp/pids/server.pid

# Compile Webpack assets
#echo "Compiling Webpack assets..."
#bundle exec rails webpacker:compile

# Then execute the container’s main process (what's set as CMD).
exec "$@"