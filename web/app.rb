require 'sinatra'
require 'json'

# Load knockscript with error handling
KNOCKSCRIPT_LOADED = false
begin
  require_relative '../knockscript'
  KNOCKSCRIPT_LOADED = true
  puts "✓ KnockScript interpreter loaded successfully"
rescue LoadError => e
  puts "✗ Failed to load knockscript: #{e.message}"
  puts "  Backtrace: #{e.backtrace.first(3).join("\n  ")}"
rescue => e
  puts "✗ Unexpected error loading knockscript: #{e.class} - #{e.message}"
  puts "  Backtrace: #{e.backtrace.first(3).join("\n  ")}"
end

# Configuration
set :bind, '0.0.0.0'
set :port, ENV['PORT'] || 4567
set :public_folder, File.dirname(__FILE__) + '/public'

# Production settings
configure :production do
  set :server, :puma
  set :logging, true
end

# CORS headers
before do
  headers 'Access-Control-Allow-Origin' => '*',
          'Access-Control-Allow-Methods' => ['GET', 'POST', 'OPTIONS'],
          'Access-Control-Allow-Headers' => 'Content-Type'
end

options '*' do
  200
end

# Startup logging
configure do
  puts "=" * 60
  puts "KnockScript Web Compiler Starting..."
  puts "=" * 60
  puts "Environment: #{ENV['RACK_ENV'] || 'development'}"
  puts "Port: #{ENV['PORT'] || 4567}"
  puts "Public folder: #{settings.public_folder}"
  puts "KnockScript loaded: #{KNOCKSCRIPT_LOADED}"
  puts "=" * 60
end

# Health check endpoint
get '/health' do
  content_type :json
  {
    status: 'ok',
    knockscript_loaded: KNOCKSCRIPT_LOADED,
    environment: ENV['RACK_ENV'] || 'development',
    port: ENV['PORT'] || 4567,
    timestamp: Time.now.to_s
  }.to_json
end

# Main page
get '/' do
  begin
    index_path = File.join(settings.public_folder, 'index.html')
    
    if File.exist?(index_path)
      send_file index_path
    else
      halt 500, { 
        'Content-Type' => 'application/json' 
      }, { 
        success: false, 
        error: "index.html not found at #{index_path}" 
      }.to_json
    end
  rescue => e
    halt 500, { 
      'Content-Type' => 'application/json' 
    }, { 
      success: false, 
      error: "Error serving index.html: #{e.message}" 
    }.to_json
  end
end

# API endpoint to compile and run KnockScript code
post '/compile' do
  content_type :json
  
  unless KNOCKSCRIPT_LOADED
    return { 
      success: false, 
      error: "KnockScript interpreter not available. Server started but interpreter failed to load." 
    }.to_json
  end
  
  begin
    data = JSON.parse(request.body.read)
    source_code = data['code']
    
    unless source_code
      return { success: false, error: "No code provided" }.to_json
    end
    
    # Run the KnockScript code
    result = KnockScript.run(source_code)
    result.to_json
    
  rescue JSON::ParserError => e
    { success: false, error: "Invalid JSON: #{e.message}" }.to_json
  rescue => e
    { success: false, error: "Runtime error: #{e.message}" }.to_json
  end
end

# Get examples
get '/examples' do
  content_type :json
  
  begin
    examples_dir = File.expand_path('../examples', File.dirname(__FILE__))
    
    examples = {}
    
    # Try to read example files
    %w[hello_world arithmetic loop_and_conditionals classes].each do |example|
      file_path = File.join(examples_dir, "#{example}.ks")
      if File.exist?(file_path)
        examples[example.to_sym] = File.read(file_path)
      end
    end
    
    if examples.empty?
      # Provide fallback examples if files not found
      examples = {
        hello_world: 'Knock knock
Who\'s there?
Print
Print who? "Hello, World!"',
        
        arithmetic: 'Knock knock
Who\'s there?
Set
Set who? x to 10

Knock knock
Who\'s there?
Print
Print who? x'
      }
    end
    
    examples.to_json
  rescue => e
    { error: "Failed to load examples: #{e.message}" }.to_json
  end
end

# 404 handler
not_found do
  content_type :json
  { success: false, error: 'Not found' }.to_json
end

# Error handler
error do
  content_type :json
  { success: false, error: 'Internal server error' }.to_json
end