# Arkency's PlusOne Slack Bot

This bot handles `+1` commands from Slack chat and adds score to person with given name. 

E.g. usage: `+1 voter101`

## Nicknames with `@`

If we specify username nick with mention prefix `@` (e.g. `+1 @voter101`). PlusOne bot will convert that nick to 
match name without prefixing `@` character.

Unfortunatelly this operation isn't performed by simple string operation. Slack converts all 
nicknames in this format. It uses it's own user format looking like this:
 
  * `<@USLACKBOT>` - unique ID for Slackbot
  * `<@U029FH1FH>` - ID of some user from our Slack

We can hit hit Slack API to fetch information about user hidden behind given tag. We presume that
user whose name doesn't begin with `<@` is valid nickname and doesn't need hitting Slack API to 
decode.

Username fetching process with **hard-coded API key** can be found in 
`app/models/username_fetcher.rb` (that information may expire soon, but I decided to include it
anyway).


