class LeaderboardsController < ApplicationController
  def show
    team = Team.find_by(slack_team_domain: params[:team_domain])
    if params[:month].present?
      @leaderboard = Leaderboards.new(team, nil).top_for_month(params[:year], params[:month])
    else
      @leaderboard = Leaderboards.new(team, nil).top_for_year(params[:year])
    end
  end
end
