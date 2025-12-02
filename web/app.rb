require 'sinatra'
require 'json'

begin
  require_relative '../knockscript'
  KNOCKSCRIPT_LOADED = true
  puts "✓ KnockScript interpreter loaded successfully"
rescue LoadError => e
  puts "✗ Failed to load knockscript (LoadError): #{e.message}"
  puts "  Backtrace: #{e.backtrace.first(5).join("\n  ")}"
  puts "  Server will continue running in degraded mode"
  KNOCKSCRIPT_LOADED = false
rescue StandardError => e
  puts "✗ Unexpected error loading knockscript: #{e.class} - #{e.message}"
  puts "  Backtrace: #{e.backtrace.first(5).join("\n  ")}"
  puts "  Server will continue running in degraded mode"
  KNOCKSCRIPT_LOADED = false
end

set :bind, '0.0.0.0'
set :port, ENV['PORT'] || 4567
set :public_folder, File.dirname(__FILE__) + '/public'

# Enable logging
set :logging, true
set :dump_errors, true
set :raise_errors, false
set :show_exceptions, false

# CORS headers
before do
  headers 'Access-Control-Allow-Origin' => '*',
          'Access-Control-Allow-Methods' => ['GET', 'POST', 'OPTIONS'],
          'Access-Control-Allow-Headers' => 'Content-Type'
end

options '*' do
  200
end

puts "=" * 60
puts "KnockScript Web Compiler Starting..."
puts "=" * 60
puts "Server: Puma (production-ready)"
puts "Environment: #{ENV['RACK_ENV'] || 'development'}"
puts "Binding: 0.0.0.0:#{ENV['PORT'] || 4567}"
puts "Port: #{ENV['PORT'] || 4567}"
puts "KnockScript loaded: #{KNOCKSCRIPT_LOADED}"
puts "Public folder: #{settings.public_folder}"
puts "=" * 60
puts "Server ready to accept connections"
puts "=" * 60

# Health check endpoint - must return 200 OK for Railway
get '/health' do
  puts "[#{Time.now.utc}] Healthcheck request received"
  content_type :json
  status 200
  {
    status: 'ok',
    knockscript_loaded: KNOCKSCRIPT_LOADED,
    timestamp: Time.now.utc.iso8601,
    port: settings.port,
    server: 'puma'
  }.to_json
end

get '/' do
  begin
    index_path = File.join(settings.public_folder, 'index.html')
    puts "Attempting to serve index.html from: #{index_path}"
    
    if File.exist?(index_path)
      send_file index_path
    else
      puts "ERROR: index.html not found at #{index_path}"
      halt 404, "index.html not found"
    end
  rescue => e
    puts "ERROR serving /: #{e.message}"
    puts "  Backtrace: #{e.backtrace.first(5).join("\n  ")}"
    halt 500, "Internal server error"
  end
end

post '/compile' do
  content_type :json
  
  unless KNOCKSCRIPT_LOADED
    return { success: false, error: "KnockScript interpreter not available" }.to_json
  end
  
  begin
    data = JSON.parse(request.body.read)
    result = KnockScript.run(data['code'])
    result.to_json
  rescue JSON::ParserError => e
    { success: false, error: "Invalid JSON: #{e.message}" }.to_json
  rescue => e
    puts "ERROR in /compile: #{e.message}"
    puts "  Backtrace: #{e.backtrace.first(10).join("\n  ")}"
    { success: false, error: e.message }.to_json
  end
end

get '/examples' do
  content_type :json
  
  begin
    examples_dir = File.expand_path('../examples', File.dirname(__FILE__))
    examples = {}
    
    %w[hello_world classes].each do |name|
      path = File.join(examples_dir, "#{name}.ks")
      examples[name.to_sym] = File.read(path) if File.exist?(path)
    end
    
    examples.to_json
  rescue => e
    puts "ERROR in /examples: #{e.message}"
    { error: e.message }.to_json
  end
end

# Catch-all error handler
error do
  e = env['sinatra.error']
  puts "ERROR: #{e.class} - #{e.message}"
  puts "  Backtrace: #{e.backtrace.first(10).join("\n  ")}"
  content_type :json
  { error: e.message }.to_json
end

puts "Server configured and ready to start..."