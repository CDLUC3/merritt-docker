require 'sinatra'
require 'sinatra/base'
require 'aws-sdk-s3'

set :bind, '0.0.0.0'

def get_file(key)

  puts key

  @s3_client = Aws::S3::Client.new(region: 'us-west-2')
  @presigner = Aws::S3::Presigner.new(client: @s3_client)
  @bucket = "uc3-s3-stg"

  url, headers = @presigner.presigned_request(
    :get_object, bucket: @bucket, key: key
  )
  if url
    response.headers['Location'] = url
    status 303
    "success: redirecting"
  else
    status 404
    "#{key} not found"
  end

end

get '/image/*' do
  image = params['splat'][0]
  get_file("#{image}")
end

get '/mods/*' do
  mods = params['splat'][0]
  get_file("mods/#{mods}")
end

get "/" do
  send_file "index.html"
end
