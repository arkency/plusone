class SlackController < ApplicationController
  skip_before_action :verify_authenticity_token

  def plus
    result = PlusOne.new.call(plus_params, team_params)

    render json: result
  rescue PlusOne::CannotPlusOneYourself
    render json: SlackMessages.cant_plus_one_yourself
  rescue PrepareRecipient::InvalidSlackToken
    render json: SlackMessages.invalid_slack_token
  end

  def alias
    result = AliasMessageParser.new(params[:text], params[:trigger_word])
    AliasToUserTag.new.call(result.user_name, result.aliass)
    render json: SlackMessages.alias_success(result.aliass, result.user_name)
  end

  def empty
    render json: SlackMessages.bot_instruction
  end

  def stats
    msg = GetStats.new.call(team_params)
    render json: {text: msg}
  end

  def givers
    msg = GetGiversStats.new.call(team_params)
    render json: {text: msg}
  end

  private

  def team_params
    params.slice(:team_id, :team_domain)
  end

  def plus_params
    params.permit(:text, :trigger_word, :user_id, :user_name)
  end

end
