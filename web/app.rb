require 'sinatra'
require 'json'

# Load knockscript with error handling
begin
  require_relative '../knockscript'
  KNOCKSCRIPT_LOADED = true
  puts "✓ KnockScript interpreter loaded successfully"
rescue LoadError => e
  puts "✗ Failed to load knockscript: #{e.message}"
  KNOCKSCRIPT_LOADED = false
rescue => e
  puts "✗ Unexpected error loading knockscript: #{e.class} - #{e.message}"
  KNOCKSCRIPT_LOADED = false
end

# Configuration
set :bind, '0.0.0.0'
set :port, ENV['PORT'] || 4567
set :public_folder, File.dirname(__FILE__) + '/public'

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
puts "=" * 60
puts "KnockScript Web Compiler Starting..."
puts "=" * 60
puts "Environment: #{ENV['RACK_ENV'] || 'development'}"
puts "Port: #{ENV['PORT'] || 4567}"
puts "KnockScript loaded: #{KNOCKSCRIPT_LOADED}"
puts "=" * 60

# Rest of your endpoints...
get '/health' do
  content_type :json
  {
    status: 'ok',
    knockscript_loaded: KNOCKSCRIPT_LOADED,
    timestamp: Time.now.to_s
  }.to_json
end

get '/' do
  send_file File.join(settings.public_folder, 'index.html')
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
    { error: e.message }.to_json
  end
end