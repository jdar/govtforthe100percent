#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f /refugeexperiences/tmp/pids/server.pid

# GOTCHA: webpacker.
# Do NOT compile Webpack assets on heroku. Use precompilation.

# Then execute the container’s main process (what's set as CMD).
exec "$@"