require "net/http"
require "json"
require "uri"

token = ENV.fetch("SLACK_BOT_TOKEN")       # xoxb-...
channel = ENV.fetch("SLACK_CHANNELID")    # e.g. C0123456789

uri = URI("https://slack.com/api/chat.postMessage")
http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = true

message = File.read(ARGV[0] || "*no data* provided")

request = Net::HTTP::Post.new(uri)
request["Authorization"] = "Bearer #{token}"
request["Content-Type"] = "application/json; charset=utf-8"
request.body = {
  channel: channel,
  mrkdwn: true,
  text: message
}.to_json

response = http.request(request)
body = JSON.parse(response.body)

if body["ok"]
  puts "Message sent. ts=#{body["ts"]}"
else
  warn "Slack API error: #{body["error"]}"
end