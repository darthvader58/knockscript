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
RUN bundle install --without development test

# Copy application code
COPY . .

# Expose port (Railway will set PORT env variable)
EXPOSE 4567

# Set environment to production
ENV RACK_ENV=production

# Start the application with Puma
CMD ["bundle", "exec", "ruby", "web/app.rb", "-o", "0.0.0.0"]