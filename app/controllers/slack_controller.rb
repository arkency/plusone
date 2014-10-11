class SlackController < ApplicationController
  skip_before_action :verify_authenticity_token

  CannotPlusOneYourself = Class.new(StandardError)

  def create
    # TODO: transaction ;)
    team = Team.find_or_initialize_by(slack_team_id: params[:team_id])
    team.slack_team_domain = params[:team_domain]
    team.save!

    sender = team.team_members.find_or_initialize_by(slack_user_name: params[:user_name])
    sender.slack_user_id = params[:user_id]
    sender.save!

    recipient = team.team_members.find_or_initialize_by(slack_user_name: recipient_name)
    recipient.save!

    raise CannotPlusOneYourself if sender == recipient
    recipient.increment(:points)

    respond_to do |format|
      format.json do
        render json: {text: "#{sender.slack_user_name}(#{sender.points}) gave +1 for #{recipient.slack_user_name}(#{recipient.points})"}
      end
    end
  rescue CannotPlusOneYourself
    respond_to do |format|
      format.json do
        render json: {text: "Nope... not gonna happen."}
      end
    end
  end

  private

  def recipient_name
    beginning = params[:trigger_word].size + 1
    text = params[:text]
    remaining = text[beginning..text.size-1]
    remaining.strip.split.first
  end
end
