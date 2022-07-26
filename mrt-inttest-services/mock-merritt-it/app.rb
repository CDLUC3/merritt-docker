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
  fn = params['splat'][0]
  fname = get_fname(fn)
  if fname.nil?
    status 404
    "Not found: #{fn}"
  else
    send_file fname
  end
end

def get_fname(val) 
  fname = "/data/static/#{val}"
  return fname if File.exist?(fname)
  fname = fname.gsub(%r[\/0\/], '/1/')
  return fname if File.exist?(fname)
  nil
end