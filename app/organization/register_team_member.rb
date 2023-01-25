class RegisterTeamMember
  def call(team_id, user_name)
    unless Team
             .find_by(slack_team_id: team_id)
             .team_members
             .exists?(slack_user_name: user_name)

    Team
      .find_by(slack_team_id: team_id)
      .team_members
      .create(slack_user_name: user_name)
    end
  end
end
