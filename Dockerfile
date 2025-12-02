# Use Ruby 3.2 as base image
FROM ruby:3.2-slim

# Install dependencies
RUN apt-get update -qq && \
    apt-get install -y build-essential && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy Gemfile and install gems
COPY Gemfile ./
COPY Gemfile.lock ./
RUN bundle install --without development test

# Copy application code
COPY . .

# Set environment to production
ENV RACK_ENV=production

# Railway will set PORT env variable
# Start the application with Puma for production performance
CMD bundle exec rackup config.ru -o 0.0.0.0 -p ${PORT:-4567} -s puma