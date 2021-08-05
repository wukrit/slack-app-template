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
    # Task Assignment Modal Block
    #
    ###
    TASK_ASSIGNMENT_MODAL_BLOCK = {
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
          "block_id": "assign_task_to",
          "type": "input",
          "optional": false,
          "element": {
            "type": "users_select",
            "placeholder": {
              "type": "plain_text",
              "text": "Select a user",
              "emoji": true
            },
            "action_id": "assignee"
          },
          "label": {
            "type": "plain_text",
            "text": "Assign task to",
            "emoji": true
          }
        },
        {
          "block_id": "task_title",
          "type": "input",
          "element": {
            "type": "plain_text_input",
            "placeholder": {
              "type": "plain_text",
              "text": "Enter task title"
            },
            "action_id": "title"
          },
          "label": {
            "type": "plain_text",
            "text": "Task Title",
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
        client.views_open(trigger_id: payload[:trigger_id], view: TASK_ASSIGNMENT_MODAL_BLOCK)
      when 'view_submission'
        params = assign_message_params(
          owner_id: payload[:user][:id],
          assignee_id: payload[:view][:state][:values][:assign_task_to][:assignee][:selected_user],
          task_title: payload[:view][:state][:values][:task_title][:title][:value],
          task_description: payload[:view][:state][:values][:task_description][:description][:value]
        )
        client.chat_postMessage(params)
      when 'block_actions'
        channel_id = payload[:container][:channel_id]
        owner_id = payload[:actions][0][:value]
        timestamp = payload[:container][:message_ts]
        blocks = payload[:message][:blocks]

        blocks[1][:text][:text] = "~#{blocks[1][:text][:text]}~ Completed"
        blocks[2][:text][:text] = "~#{blocks[2][:text][:text]}~"
        blocks.pop

        client.chat_update(channel: channel_id, ts: timestamp, blocks: blocks)
      end

      200
    end

    # Use this to verify that your server is running and handling requests.
    get '/' do
      'Hello, world!'
    end

    private

    def assign_message_params(owner_id:, assignee_id:, task_title:, task_description:)
      self_assigned = "You've assigned a new task to yourself." if owner_id == assignee_id

      {
        "channel": assignee_id,
        "blocks": [
          {
            "type": "context",
            "elements": [
              {
                "type": "mrkdwn",
                "text": self_assigned || "<@#{owner_id}> has assigned you a new task."
              }
            ]
          },
          {
            "type": "section",
            "text": {
              "type": "mrkdwn",
              "text": "*#{task_title}*"
            }
          },
          {
            "type": "section",
            "text": {
              "type": "mrkdwn",
              "text": task_description
            }
          },
          {
            "type": "actions",
            "elements": [
              {
                "type": "button",
                "text": {
                  "type": "plain_text",
                  "text": "Mark Completed",
                  "emoji": true
                },
                "value": owner_id,
                "style": "primary",
                "action_id": "task_complete"
              }
            ]
          }
        ]
      }
    end
  end
end
