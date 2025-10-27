echo "Starting KnockScript Web Compiler..."
echo "Port: ${PORT:-4567}"
echo "Environment: ${RACK_ENV:-production}"

# Start Puma with the configuration file
bundle exec puma -C config/puma.rb config.ru