# Arkency's PlusOne Slack Bot

This project is quick implementation for plusone bot. It is like giving +1 points on message board.

Example usage:

![example use of plusone bot](http://i.imgur.com/6loapQ5.png)

You can also +1 any string or even an emoticon. We don't limit it to just the valid usernames on Slack. 
One usecase is to create a custom Slack emoticon for the people and then use the emoticons when +1'ing. This makes a nice visual effect.

# Setup

1. Deploy application on publicly available server. E.g. [Heroku](http://heroku.com/)
  1. Remember about setting up database
  2. Run migration: `rake db:migrate`
2. Get URL of your application.
3. Setup `Outgoing WebHooks` on [Slack Integrations page](https://arkency.slack.com/services/new/outgoing-webhook)
  ![Slack's outgoing hook configuration](http://i.imgur.com/osQIqaW.png)
4. Add environmental variable with your Slack API key:
  1. You can generate key here: https://api.slack.com/web
  2. Set environmental variable called `SLACK_API_TOKEN`


## About

<img src="http://arkency.com/images/arkency.png" alt="Arkency" width="20%" align="left" />

This repository is funded and maintained by Arkency. Check out our other [open-source projects](https://github.com/arkency).

You can [read our blog](http://blog.arkency.com). We write about Rails and JavaScript development.
