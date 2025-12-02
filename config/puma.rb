# Puma configuration file for Railway deployment

# Use the PORT environment variable provided by Railway
port ENV.fetch("PORT") { 4567 }

# Bind to all interfaces so Railway can reach the app
bind "tcp://0.0.0.0:#{ENV.fetch('PORT') { 4567 }}"

# Set the environment
environment ENV.fetch("RACK_ENV") { "production" }

# Number of worker processes (start with 0 for single-process mode)
workers ENV.fetch("WEB_CONCURRENCY") { 0 }

# Preload the application for better performance
preload_app!

# Logging
stdout_redirect nil, nil, true

# Allow puma to be restarted by `rails restart` command
plugin :tmp_restart
