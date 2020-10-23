require 'sinatra'
require 'sinatra/base'

set :bind, '0.0.0.0'

get '/*' do
  puts("GET #{params}")
  status 200
  "GET"
end

post '/*' do
  puts("POST #{params}")
  status 200
  "POST"
end

put '/*' do
  puts("PUT #{params}")
  status 200
  "PUT"
end
