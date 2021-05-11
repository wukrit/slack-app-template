# slack-app-template

This is a basic app for working with Slack interactions and the Slack Web API. The current implementation posts back "Hello, [your name]!" in response to any interaction.

## Before getting started

Before you can configure the app, you should have received some info from Donut devs, in addition to this repo.

`SLACK_BOT_TOKEN` - This is the token that will authenticate the requests you make to the slack API.

`NGROK_AUTH` - This is the token that will allow you to use an ngrok tunnel with a persistent url.

`NGROK_SUBOMAIN` - This is the subdomain for the aforementioend persisent url.

## Running the App

### Without docker

The application assumes Ruby version 2.7.3 & bundler version 2.1.4.

Install [Bundler](https://bundler.io/):

```sh
gem install bundler:2.1.4
```

Install all the required gems:

```sh
bundle install
```

Copy the `.env.example` file.

```sh
cp .env.example .env
```

Open the file in your editor and replace the placeholder slack token with the one you've received from Donut.

Use the following command to run your app at http://localhost:4567/:

```sh
bundle exec rackup --host 0.0.0.0
```

Visit <http://localhost:4567/> to check that it's working.

In order for the slack bot to send your locally running application requests, you need ngrok to open a tunnel.

First we need to authenticate.

```sh
ngrok authtoken <your_ngrok_token_here>
```

This will persist, so you don't need to run it every time you want to open the tunnel.

Next we have to open the tunnel:

```sh
ngrok http -subdomain=<your_ngrok_subdomain_here> 4567
```

Now, when you visit `https://<your_ngrok_subdomain_here>.ngrok.io`, traffic will be routed to your locally running instance of this application.

### With docker

We assume that you already have docker installed are familiar with it if you are using it as part of this code challenge.

Copy the `.env.docker.example` file.

```sh
sp .env.docker.example .env.docker
```

Open the new file in your editor, and replace the placeholder values with the corresponding values provided by Donut. You should end up with three env vars defined, `SLACK_BOT_TOKEN`, `NGROK_AUTH` & `NGROK_SUBDOMAIN`.

```sh
docker compose build
```

Install the gems:

```sh
docker compose run --rm api bundle install
```

```sh
docker compose up
```

Now, when you visit `https://<your_ngrok_subdomain_here>.ngrok.io`, traffic will be routed to your locally running instance of this application.

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
