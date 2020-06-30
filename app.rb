require 'sinatra'
require 'sinatra/reloader' if settings.development?
require 'dotenv/load' if settings.development?
require 'slack'

Slack.configure do |config|
  config.token = ENV['SLACK_BOT_TOKEN']
end

post '/interactions' do
  payload = JSON.parse(params[:payload], symbolize_names: true)

  client = Slack::Web::Client.new
  channel_id = client.conversations_open(users: payload[:user][:id]).channel.id
  client.chat_postMessage(channel: channel_id, text: 'Hello, world!')

  200
end

# Use this to verify that your server is running and handling requests.
get '/' do
  'Hello, world!'
end
