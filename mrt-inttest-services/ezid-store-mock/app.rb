require 'sinatra'
require 'sinatra/base'

set :bind, '0.0.0.0'

def fake_ark(shoulder)
  # force a relatively unique 7 digit number
  num = Time.now.to_i % 8999999 + 1000000
  "#{shoulder}#{num}"
end

# get method is just for debugging
get '/id/*' do
  ark = params['splat'][0]
  status 200
  "success: #{ark}"
end

# get method is just for debugging
get '/shoulder/*' do
  shoulder = params['splat'][0]
  ark = fake_ark(shoulder)
  status 200
  "success: #{ark}"
end

get '/*' do
  status 200
  "N/A"
end

put '/*' do
  status 200
  "N/A"
end

post '/id/*' do
  ark = params['splat'][0]
  status 200
  "success: #{ark}"
end

post '/shoulder/*' do
  shoulder = params['splat'][0]
  ark = fake_ark(shoulder)
  status 200
  "success: #{ark}"
end

# fake storage add function
post '/add/*' do
  status 200
  "<entity>foo</entity>"
end
