require 'sinatra'
require 'sinatra/base'
require 'mustache'
require 'cgi'

set :bind, '0.0.0.0'

get '/storage/manifest/*/*' do
  node = params['splat'][0]
  ark = params['splat'][1]
  content_type 'application/xml'
  Mustache.render(File.open('/data/manifest').read, {'node': node, 'ark': ark})
end

get '/storage/content/*/*/*/producer/*' do
  node = params['splat'][0]
  ark = params['splat'][1]
  ver = params['splat'][2]
  path = params['splat'][3]

  fname = "/data/producer/#{path}"
  if File.exist?(fname)
    if path =~ %r[\.xml$]
      content_type 'application/xml'
    elsif path =~ %r[\.txt$]
      content_type 'text/plain'
    end
    send_file fname
  else
    status 404
    "Not found: #{fname}"
  end
end

get '/storage/content/*/*/*/system/*' do
  node = params['splat'][0]
  ark = params['splat'][1]
  ver = params['splat'][2]
  path = params['splat'][3]
  fname = "/data/system/#{path}"
  if File.exist?(fname)
    if path =~ %r[\.xml$]
      content_type 'application/xml'
    elsif path =~ %r[\.txt$]
      content_type 'text/plain'
    end
    Mustache.render(File.open(fname).read, {'node': node, 'ark': ark})
  else
    status 404
    "Not found: #{fname}"
  end
end

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