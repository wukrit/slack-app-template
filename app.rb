require 'sinatra'
require 'sinatra/custom_logger'
require 'sinatra/reloader' if settings.development?
require 'dotenv/load' if settings.development?
require 'logger'
require 'slack'

Slack.configure do |config|
  config.token = ENV['SLACK_BOT_TOKEN']
end

module Donut
  class App < Sinatra::Base
    helpers Sinatra::CustomLogger

    ###
    #
    # Custom logging
    #
    ###
    def self.logger
      @logger ||= Logger.new(STDERR)
    end

    configure :development, :production do
      register Sinatra::Reloader
      set :logger, Donut::App.logger
    end

    ###
    #
    # Task Assignment Modal Payload
    #
    ###
    TASK_ASSIGNMENT_MODAL_PAYLOAD = {
      "type": "modal",
      "title": {
        "type": "plain_text",
        "text": "Assign a Task",
        "emoji": true
      },
      "submit": {
        "type": "plain_text",
        "text": "Submit",
        "emoji": true
      },
      "close": {
        "type": "plain_text",
        "text": "Cancel",
        "emoji": true
      },
      "blocks": [
        {
          "type": "divider"
        },
        {
          "block_id": "request_task_from",
          "type": "input",
          "optional": false,
          "element": {
            "type": "users_select",
            "placeholder": {
              "type": "plain_text",
              "text": "Select a user",
              "emoji": true
            },
            "action_id": "assignee_id"
          },
          "label": {
            "type": "plain_text",
            "text": "Assign task to",
            "emoji": true
          }
        },
        {
          "block_id": "task_description",
          "type": "input",
          "element": {
            "type": "plain_text_input",
            "multiline": true,
            "placeholder": {
              "type": "plain_text",
              "text": "Enter task description"
            },
            "action_id": "description"
          },
          "label": {
            "type": "plain_text",
            "text": "Description of task:",
            "emoji": true
          }
        }
      ]
    }.freeze

    ###
    #
    # Routes
    #
    ###
    post '/interactions' do
      payload = JSON.parse(params[:payload], symbolize_names: true)
      Donut::App.logger.info "\n[+] Interaction type #{payload[:type]} recieved."
      Donut::App.logger.info "\n[+] Payload:\n#{JSON.pretty_generate(payload)}"

      client = Slack::Web::Client.new

      case payload[:type]
      when 'shortcut'
        client.views_open(trigger_id: payload[:trigger_id], view: TASK_ASSIGNMENT_MODAL_PAYLOAD)
      end

      200
    end

    # Use this to verify that your server is running and handling requests.
    get '/' do
      'Hello, world!'
    end
  end
end
