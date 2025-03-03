#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f /refugeexperiences/tmp/pids/server.pid

# GOTCHA: webpacker.
# Do NOT compile Webpack assets on heroku, due to memory constraints

# Then execute the container’s main process (what's set as CMD).
exec "$@"