require 'sinatra'
require 'sinatra/base'

set :bind, '0.0.0.0'

get '/' do
  send_file "/data/index.html"
end

get '/store/state/7777?t=anvl' do
  send_file "/data/7777.anvl"

end

get '/*' do
  val = params['splat'][0]
  puts val
  status 200
  "success: #{val}"
end