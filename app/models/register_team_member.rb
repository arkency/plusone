class RegisterTeamMember
  def call(team_id, user_name)
    Team
      .find_by(slack_team_id: team_id)
      .team_members
      .find_or_create_by(slack_user_name: user_name)
  end
end
