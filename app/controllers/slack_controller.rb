class SlackController < ApplicationController
  skip_before_action :verify_authenticity_token

  def plus
    recipient, sender =
      GiveUpvote.new.call(user_name, message, trigger_word, team)
    render json: SlackMessages.slack_output_message(recipient, sender)
  rescue GiveUpvote::CannotUpvoteYourself
    render json: SlackMessages.cant_plus_one_yourself
  rescue PrepareRecipient::InvalidSlackToken
    render json: SlackMessages.invalid_slack_token
  end

  def alias
    username, user_alias = SlackAliasMessageParser.parse(message, trigger_word).values_at(:username, :user_alias)
    AliasToUserTag.new.call(username, user_alias)

    render json: SlackMessages.alias_success(user_alias, username)

  rescue Parslet::ParseFailed
    render json: SlackMessages.raw("Invalid user tag")
  end

  def empty
    render json: SlackMessages.bot_instruction
  end

  def stats
    render json: SlackMessages.raw(stats_query.received_upvotes)
  end

  def givers
    render json: SlackMessages.raw(stats_query.given_upvotes)
  end

  def leaderboard
    render json: SlackMessages.leaderboards(Leaderboards.new(team))
  end

  private

  def stats_query
    Stats.new(team.id)
  end

  def team
    Team.register(slack_team_id, slack_team_domain)
  end

  def slack_team_domain
    params.fetch(:team_domain)
  end

  def slack_team_id
    params.fetch(:team_id)
  end

  def user_name
    params.fetch(:user_name)
  end

  def trigger_word
    params.fetch(:trigger_word)
  end

  def message
    params.fetch(:text)
  end
end
