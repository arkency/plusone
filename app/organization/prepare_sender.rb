class PrepareSender
  def call(team_id, slack_user_name, slack_user_id)
    team = Team.find_by(slack_team_id: team_id)
    member = team.team_members.find_by(slack_user_name: slack_user_name)
    member.slack_user_id = slack_user_id
    member.save!
    member
  end
end
