class PrepareTeamMember
  def call(team, user_name, slack_id = nil)
    member = team.team_members.find_or_initialize_by(slack_user_name: user_name)
    member.slack_user_id = slack_id unless slack_id.nil?
    member.save!
    member
  end
end
