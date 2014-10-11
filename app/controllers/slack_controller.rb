class SlackController < ApplicationController
  skip_before_action :verify_authenticity_token

  CannotPlusOneYourself = Class.new(StandardError)
  MissingRecipient = Class.new(StandardError)

  def create
    # TODO: transaction ;)
    team = Team.find_or_initialize_by(slack_team_id: params[:team_id])
    team.slack_team_domain = params[:team_domain]
    team.save!

    sender = team.team_members.find_or_initialize_by(slack_user_name: params[:user_name])
    sender.slack_user_id = params[:user_id]
    sender.save!

    recipient_name.present? or raise MissingRecipient

    recipient = team.team_members.find_or_initialize_by(slack_user_name: recipient_name)
    recipient.save!

    raise CannotPlusOneYourself if sender == recipient
    recipient.increment!(:points)

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

  def empty
    respond_to do |format|
      format.json do
        render json: {text: "?"}
      end
    end
  end

  def stats
    team = Team.find_or_initialize_by(slack_team_id: params[:team_id])
    team.slack_team_domain = params[:team_domain]
    team.save!

    msg = team.team_members.sort_by{|tm| tm.points }.reverse.map{|tm| "#{tm.slack_user_name}: #{tm.points}"}.join(", ")

    respond_to do |format|
      format.json do
        render json: {text: msg}
      end
    end
  end

  private

  def recipient_name
    MessageParser.new(params[:text], params[:trigger_word]).recipient_name
  end
end
