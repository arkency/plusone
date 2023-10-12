class LeaderboardsController < ApplicationController
  def show
    team = Team.find_by(slack_team_domain: params[:team_domain])
    @leaderboard = Leaderboards.new(team, nil).top_for_year(params[:year])
  end
end
