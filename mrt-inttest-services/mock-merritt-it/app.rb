require 'sinatra'
require 'sinatra/base'
require 'mustache'
require 'redcarpet'
require 'cgi'

set :bind, '0.0.0.0'

def readme
  renderer = Redcarpet::Render::HTML.new
  markdown = Redcarpet::Markdown.new(renderer, {tables: true})
  markdown.render(File.open('/data/README.md').read)
end

get '/' do
  readme
end

get '' do
  readme
end


get '/storage/manifest/*/*' do
  node = params['splat'][0]
  ark = params['splat'][1]
  content_type 'application/xml'
  Mustache.render(File.open('/data/manifest').read, {'node': node, 'ark': ark})
end

def get_file(fname)
  if File.exist?(fname)
    if fname =~ %r[\.xml$]
      content_type 'application/xml'
    elsif fname =~ %r[\.txt$]
      content_type 'text/plain'
    end
    send_file fname
  else
    status 404
    "Not found: #{fname}"
  end
end

def get_producer(params)
  node = params['splat'][0]
  ark = params['splat'][1]
  ver = params['splat'][2]
  path = params['splat'][3]

  get_file("/data/producer/#{path}")
end

get '/storage/content/*/*/*/producer/*' do
  get_producer(params)
end

get '/store/content/*/*/*/producer/*' do
  get_producer(params)
end

get '/storage-input/*' do
  path = params['splat'][0]
  get_file("/data/#{path}")
end

def get_system(params) 
  node = params['splat'][0]
  ark = params['splat'][1]
  ver = params['splat'][2]
  path = params['splat'][3]
  get_file("/data/system/#{path}")
end

get '/storage/content/*/*/*/system/*' do
  get_system(params)
end

get '/store/content/*/*/*/system/*' do
  get_system(params)
end

get '/store/state/7777' do
  send_file "/data/7777.anvl" if params[:t] == "anvl"
  "Specify ?t=anvl to download the file"
end

get '/store/state/8888' do
  send_file "/data/8888.anvl" if params[:t] == "anvl"
  "Specify ?t=anvl to download the file"
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