require 'sinatra'
require 'sinatra/base'
require 'cgi'

set :bind, '0.0.0.0'

get '/store/state/7777' do
  send_file "/data/7777.anvl" if params[:t] == "anvl"
  "success: store/state/7777"
end

get '/store/state/8888' do
  send_file "/data/8888.anvl" if params[:t] == "anvl"
  "success: store/state/8888"
end

get '/static/*' do
  val = params['splat'][0]
  fname = "/data/static/#{val}"
  if File.exist?(fname)
    send_file "/data/static/#{val}"
  else
    "Not found: #{fname}"
  end
end