class SlackController < ApplicationController
  skip_before_action :verify_authenticity_token

  CannotPlusOneYourself = Class.new(StandardError)
  MissingRecipient = Class.new(StandardError)

  def create
    # TODO: transaction ;)
    team = Team.find_or_initialize_by(slack_team_id: params[:team_id])
    team.slack_team_domain = params[:team_domain]
    team.save!

    sender_username = clean_name(username_fetcher.(params[:user_name]))
    sender = team.team_members.find_or_initialize_by(slack_user_name: sender_username)
    sender.slack_user_id = params[:user_id]
    sender.save!

    recipient_name.present? or raise MissingRecipient

    recipient_username = clean_name(username_fetcher.(recipient_name))
    recipient = team.team_members.find_or_initialize_by(slack_user_name: recipient_username)
    recipient.save!

    raise CannotPlusOneYourself if sender == recipient
    recipient.increment!(:points)

    respond_to do |format|
      format.json do
        render json: {
                   text: "#{sender_username}(#{sender.points}) gave +1 for #{recipient_username}(#{recipient.points})",
                   parse: "none"
               }
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

  def index
    teams = Team.preload(:team_members).limit(10)
    team = teams[0]
    team_members = team ? team.team_members.sort_by{|tm| tm.points }.reverse : []
    render locals: {teams: teams, team_members: team_members}
  end

  private

  def recipient_name
    MessageParser.new(params[:text], params[:trigger_word]).recipient_name
  end

  def username_fetcher
    UsernameFetcher.new
  end

  def clean_name(name)
    name.gsub(/^(@+)/, "")
  end
end
