class SlackController < ApplicationController
  skip_before_action :verify_authenticity_token

  def plus
    team = PrepareTeam.new.call(team_params)
    result = PlusOne.new(team).call(plus_params)
    respond_to do |format|
      format.json do
        render json: result
      end
    end
  rescue PlusOne::CannotPlusOneYourself
    respond_to do |format|
      format.json do
        render json: {text: "Nope... not gonna happen."}
      end
    end
  rescue PlusOne::InvalidSlackToken
    respond_to do |format|
      format.json do
        render json: {text: "This slack team doesn't have specified slack token(or it's invalid). Please use nickname without @"}
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
    msg = GetStats.new.call(team_params)
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

  def team_params
    params.slice(:team_id, :team_domain)
  end

  def plus_params
    params.permit(:text, :trigger_word, :user_id, :user_name)
  end

end
