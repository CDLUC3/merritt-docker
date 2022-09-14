require 'sinatra'
require 'sinatra/base'
require 'mustache'
require 'redcarpet'
require 'cgi'
require 'json'

set :bind, '0.0.0.0'

# Useful functions

def readme
  renderer = Redcarpet::Render::HTML.new
  markdown = Redcarpet::Markdown.new(renderer, {tables: true})
  markdown.render(File.open('/data/README.md').read)
end

get '/' do
  readme
end

def processing
  return false if File.exist?("/tmp/mock.hold")
  true
end

def get_status
  {
    processing: processing
  }.to_json
end

def status_404
  status 404
  {
    processing: processing
  }.to_json
end

get '/status' do
  get_status
end

post '/status/start' do
  hold_file = File.new("/tmp/mock.hold", "w")
  File.delete(hold_file) if File.exist?(hold_file)
  get_status
end

post '/status/stop' do
  hold_file = File.new("/tmp/mock.hold", "w")
  hold_file.puts("")
  hold_file.close
  get_status
end

get '' do
  readme
end

def get_file(fname)
  return status_404 unless processing
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

def get_system(params) 
  node = params['splat'][0]
  ark = params['splat'][1]
  ver = params['splat'][2]
  path = params['splat'][3]
  get_file("/data/system/#{path}")
end

get '/static/*' do
  return status_404 unless processing
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

# delete ingest queue directory
delete '/ingest-queue' do
  fname = "/tdr/ingest/queue"
  puts %x{ find #{fname} }
  %x{ rm -rf #{fname} }
  %x{ mkdir #{fname} }
  puts 'test2'
  puts %x{ find #{fname} }
end

# mock data creation

get '/storage-input/*' do
  path = params['splat'][0]
  get_file("/data/#{path}")
end


# Mock Storage

get '/storage/manifest/*/*' do
  return get_status unless processing
  node = params['splat'][0]
  ark = params['splat'][1]
  content_type 'application/xml'
  manifest = ark =~ %r[ark:\/v3.*] ? "manifestv3" : "manifest"
  Mustache.render(File.open("/data/#{manifest}").read, {'node': node, 'ark': ark})
end


get '/storage/content/*/*/*/producer/*' do
  get_producer(params)
end

get '/store/content/*/*/*/producer/*' do
  get_producer(params)
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

get '/hostname' do
  content_type 'application/json'
  {
    "hostname": "mock-merritt-it",
    "canonicalHostname": "mock-merritt-it",
    "hostAddress": "na"
  }.to_json  
end

post '/add/*/*' do
  node = params['splat'][0]
  ark = params['splat'][1]
  if ark == 'ark/9999/2222'
    sleep 20
  end
  status 200
  "<entity>foo</entity>"
end

post '/update/*' do
  status 200
  "<entity>foo</entity>"
end

# Mock Inventory

get '/inventory/*' do
  status 200
  content_type 'application/xml'
  "<entity>foo</entity>"
end

post '/inventory/*' do
  status 200
  content_type 'application/xml'
  "<entity>foo</entity>"
end

# Mock EZID

def fake_ark(shoulder)
  # force a relatively unique 7 digit number
  num = Time.now.to_i % 8999999 + 1000000
  "#{shoulder}#{num}"
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