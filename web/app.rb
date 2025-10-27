require 'sinatra'
require 'json'
require_relative '../knockscript'

# Set Sinatra to run on all interfaces
set :bind, '0.0.0.0'
set :port, ENV['PORT'] || 4567

# Enable sessions and set production settings
configure :production do
  set :server, :puma
end

# CORS headers for API requests
before do
  headers 'Access-Control-Allow-Origin' => '*',
          'Access-Control-Allow-Methods' => ['GET', 'POST', 'OPTIONS'],
          'Access-Control-Allow-Headers' => 'Content-Type'
end

options '*' do
  200
end

# Serve static files
set :public_folder, File.dirname(__FILE__) + '/public'

# Main page
get '/' do
  send_file File.join(settings.public_folder, 'index.html')
end

# API endpoint to compile and run KnockScript code
post '/compile' do
  content_type :json
  
  begin
    data = JSON.parse(request.body.read)
    source_code = data['code']
    
    # Run the KnockScript code
    result = KnockScript.run(source_code)
    
    result.to_json
  rescue JSON::ParserError => e
    { success: false, error: "Invalid JSON: #{e.message}" }.to_json
  rescue => e
    { success: false, error: e.message }.to_json
  end
end

get '/examples' do
  content_type :json
  
  examples = {
    hello_world: File.read('../examples/hello_world.ks'),
    arithmetic: File.read('../examples/arithmetic.ks'),
    loops: File.read('../examples/loop_and_conditionals.ks'),
    classes: File.read('../examples/classes.ks')
  }
  
  examples.to_json
rescue => e
  { error: e.message }.to_json
end