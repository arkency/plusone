class SlackController < ApplicationController
  skip_before_action :verify_authenticity_token

  def plus
    team = PrepareTeam.new.call(team_params)
    upvote_uuid = SecureRandom.uuid
    ActiveRecord::Base.transaction do
      cmd = Command::GiveUpvote.new(team_id: team.id, params: plus_params, upvote_uuid: upvote_uuid)
      command_bus.(cmd)
    end

    upvote = Upvote.find_by(uuid: upvote_uuid)
    result = 
      {
        text: "#{upvote.sender.slack_user_name}(#{upvote.sender.points}) gave +1 for #{upvote.recipients.first.slack_user_name}(#{upvote.recipients.first.points})",
        parse: "none"
      }

    render json: result
  rescue Domain::Sender::CannotUpvoteYourself
    cant_upvote_yourself
  rescue Domain::Sender::InvalidSlackToken
    invalid_slack_token
  end

  def empty
    render json: {text: bot_instruction }
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

  def bot_instruction
    "PlusOne bot instruction:\n" +
    "-Use '+1 @name' if you want to appreciate someone\n" +
    "-Use '+1 !stats' to get statistics\n" +
    "-Use '+1 !givers' to get givers statistics\n" +
    "Want to help with PlusOne development? Feel welcome: https://github.com/arkency/plusone"
  end

  def cant_upvote_yourself
    render json: {text: "Nope... not gonna happen."}
  end

  def invalid_slack_token
    render json: {text: "This slack team doesn't have specified slack token(or it's invalid). Please use nickname without @"}
  end
end
