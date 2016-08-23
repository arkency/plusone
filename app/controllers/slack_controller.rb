class SlackController < ApplicationController
  skip_before_action :verify_authenticity_token

  def plus
    team = PrepareTeam.new.call(team_params)
    result = PlusOne.new(team).call(plus_params)

    render json: result
  rescue PlusOne::CannotPlusOneYourself
    cant_plus_one_yourself
  rescue PlusOne::InvalidSlackToken
    invalid_slack_token
  end

  def empty
    render json: {text: bot_instruction }
  end

  def stats
    msg = GetStats.new.call(team_params)
    render json: {text: msg}
  end

  private

  def team_params
    params.slice(:team_id, :team_domain)
  end

  def plus_params
    params.permit(:text, :trigger_word, :user_id, :user_name)
  end

  def bot_instruction
    "PlusOne bot instruction:\n" +
    "-Use '+1 @name' if you want to appreciate someone\n" +
    "-Use '+1 !stats' to get statistics\n" +
    "Want to help with PlusOne development? Feel welcome: https://github.com/arkency/plusone"
  end

  def cant_plus_one_yourself
    render json: {text: "Nope... not gonna happen."}
  end

  def invalid_slack_token
    render json: {text: "This slack team doesn't have specified slack token(or it's invalid). Please use nickname without @"}
  end
end
