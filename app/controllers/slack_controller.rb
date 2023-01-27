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
    result = SlackAliasMessageParser.parse(message, trigger_word)
    AliasToUserTag.new.call(result.fetch(:username), result.fetch(:user_alias))

    render json: SlackMessages.alias_success(result.fetch(:user_alias), result.fetch(:username))

  rescue Parslet::ParseFailed
    render json: SlackMessages.raw("Invalid user tag"), status: :bad_request
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
