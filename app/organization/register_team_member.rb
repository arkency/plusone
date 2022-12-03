class RegisterTeamMember
  def call(team_id, user_name, slack_user_id)
    Team
      .find_by(slack_team_id: team_id)
      .team_members
      .create(slack_user_name: user_name, slack_user_id: slack_user_id)
  end
end
