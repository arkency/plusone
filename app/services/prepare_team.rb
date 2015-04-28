class PrepareTeam
  def call(team_params)
    team = Team.find_or_initialize_by(slack_team_id: team_params[:team_id])
    team.slack_team_domain = team_params[:team_domain]
    team.save!
    team
  end
end