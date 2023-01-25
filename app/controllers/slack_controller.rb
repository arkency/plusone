class SlackController < ApplicationController
  skip_before_action :verify_authenticity_token

  def plus
    result =
      PlusOne.new.call(user_name, message, trigger_word, team_id, team_domain)

    render json: result
  rescue PlusOne::CannotPlusOneYourself
    render json: SlackMessages.cant_plus_one_yourself
  rescue PrepareRecipient::InvalidSlackToken
    render json: SlackMessages.invalid_slack_token
  end

  def alias
    result = AliasMessageParser.new(message, trigger_word)
    AliasToUserTag.new.call(result.user_name, result.aliass)
    render json: SlackMessages.alias_success(result.aliass, result.user_name)
  end

  def empty
    render json: SlackMessages.bot_instruction
  end

  def stats
    msg = stats_query.received_upvotes
    render json: { text: msg }
  end

  def givers
    msg = stats_query.given_upvotes
    render json: { text: msg }
  end

  private

  def stats_query
    Stats.new(team_id, team_domain)
  end

  def team_domain
    team_params.fetch(:team_domain)
  end

  def team_id
    team_params.fetch(:team_id)
  end

  def user_name
    plus_params.fetch(:user_name)
  end

  def trigger_word
    params.fetch(:trigger_word)
  end

  def message
    params.fetch(:text)
  end

  def team_params
    params.permit(:team_id, :team_domain)
  end

  def plus_params
    params.permit(:text, :trigger_word, :user_id, :user_name)
  end
end
