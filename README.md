# slack-app-template

This is a basic app for working with Slack interactions and the Slack Web API. The current implementation posts back "Hello, [your name]!" in response to any interaction.

## Running the App
Install [Bundler](https://bundler.io/):
```
gem install bundler
```
Install all the required gems:
```
bundle install
```
Use the following command to run your app at http://localhost:4567/:
```
ruby app.rb
```
Visit http://localhost:4567/ to check that it's working.

## Slack App Setup
### Create Workspace and App
Create a new Slack workspace as your sandbox. Once you have the workspace, you can [create your app](https://api.slack.com/apps).
### Add Permissions
For this app to function the Slack app needs the following Bot Token Scopes:
1. `im:write` — to use `conversations.open` to open a DM
1. `chat:write` — to use `chat.postMessage` to send a DM
1. `commands` — to add a Slack shortcut as an easy interactive entry point
### Configure Interactive Endpoint
Under the Slack settings for Interactivity & Shortcuts you need to add a URL where Slack will send requests for interactions. You can use [ngrok](https://ngrok.com/) to set up a URL that points back to your local server. Point it at the `/interactions` endpoint. A full ngrok URL will look something like https://my-subdomain.ngrok.io/interactions.
### Add a Global Shortcut
Under the Interactivity & Shortcuts settings you can **Create New Shortcut** — add a Global Shortcut with whatever you want for the name and callback ID.
### Installing
1. Go to Install App in the Slack settings and click the button to install. You will receive a Bot User OAuth Access Token.
1. Add a `.env` file to your repository with `SLACK_BOT_TOKEN=your_token_here`
### Test It!
Now you should be ready to test it out. In your Slack workspace use the shortcut menu :zap: to select your shortcut. If everything is set up then your app should send you a DM with "Hello, [your name]!"
