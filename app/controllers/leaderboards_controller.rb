class LeaderboardsController < ApplicationController
  def show
    team = Team.find_by(slack_team_domain: params[:team_domain])
    @leaderboard = Leaderboards.new(team).top_for_this_year
  end
end