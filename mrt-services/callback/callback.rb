# frozen_string_literal: true

require 'rubygems'
require 'bundler/setup'

require 'sinatra'
require 'sinatra/base'

require 'json'
require 'httpclient'

require 'base64'
require 'uri'

# ruby app.rb -o 0.0.0.0
set :port, 8098

set :bind, '0.0.0.0'

get '/status/*' do
  status params['splat'][0].to_i
  headers['foo'] = 'bar1'
  { message: 'hello' }.to_json
end

post '/status/*' do
  status params['splat'][0].to_i
  headers['foo'] = 'bar1'
  { message: 'hello' }.to_json
end

get '/*' do
  puts "GET #{params['splat'][0]}"
  puts "\t#{params}"
end

post '/mc/:jid' do |jid|
  data = JSON.parse(request.body.read)
  job_status = data['job:jobState']['job:jobStatus']
  if job_status.eql? 'COMPLETED'
    puts "JOB SUCCESS: #{jid}"
  else
    puts "JOB FAILURE: #{jid}"
  end
  puts data
  status 200
  body data.to_s
end
