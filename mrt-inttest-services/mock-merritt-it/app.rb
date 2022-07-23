require 'sinatra'
require 'sinatra/base'

set :bind, '0.0.0.0'

get '/store/state/7777?t=anvl' do
  send_file "/data/7777.anvl"
end

get '/store/state/7777' do
  send_file "/data/7777.anvl" if params[:t] == "anvl"
  "success: store/state/7777"
end

get '/store/state/8888?t=anvl' do
  send_file "/data/8888.anvl"
end

get '/static/*' do
  val = params['splat'][0]
  send_file "/data/static/#{val}"
end