max_threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }
min_threads_count = ENV.fetch("RAILS_MIN_THREADS") { max_threads_count }
threads min_threads_count, max_threads_count

# Specifies the `port` that Puma will listen on
port ENV.fetch("PORT") { 4567 }

# Specifies the `environment` that Puma will run in
environment ENV.fetch("RACK_ENV") { "production" }

# Allow puma to be restarted by `bin/rails restart` command
plugin :tmp_restart

# Bind to all interfaces
bind "tcp://0.0.0.0:#{ENV.fetch('PORT') { 4567 }}"

# Workers (for production, you can increase this)
workers ENV.fetch("WEB_CONCURRENCY") { 2 }

# Preload application for better performance
preload_app!