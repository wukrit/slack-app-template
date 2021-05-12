# slack-app-template

Hi there! This is the template app for the Donut code challenge. In addition to this repo, some other configuration has already happened.

You will have been invited to a slack workspace. A bot has been configured in that workspace, which you will be writing the backend for.

You will have received three values from Donut devs necessary to configure your app.

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
bundle exec rackup --host 0.0.0.0 -p 4567
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

Now, when you visit `https://<your_ngrok_subdomain_here>.ngrok.io`, or when slack sends requests to it, the traffic will be routed to your locally running instance of this application.

### With docker

We assume that you already have docker installed are familiar with it if you are using it as part of this code challenge.

Copy the `.env.docker.example` file.

```sh
cp .env.docker.example .env.docker
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

Now, when you visit `https://<your_ngrok_subdomain_here>.ngrok.io`, or when slack sends requests to it, the traffic will be routed to your locally running instance of this application.

## Testing end to end

Ok! Let's test the slack bot. In slack, go to the workspace you were invited to for this challenge.

The bot is configured with a shortcut, `/donut`. Try typing that into a channel that you & the bot are both in. It should send you a message, which is the result of the boilerplate code already present in this repo, at the `/interactions` endpoint. You should also see log output of the json received from slack on your local machine.

You should be all set to start to work through the project brief! If you have any questions, you have been invited to a personalized help channel in the slack workspace as well. Feel free to pop in and ask questions if you are having a hard time getting anything setup, or would like clarifications on the brief.
