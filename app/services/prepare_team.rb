class PrepareTeam
  def call(slack_team_id, slack_team_domain)
    team = Team.find_or_initialize_by(slack_team_id: slack_team_id)
    team.slack_team_domain = slack_team_domain
    team.save!
    team
  end
end