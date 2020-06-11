class PrepareSender
  def initialize(team)
    @team = team
  end

  def call(slack_user_name, slack_user_id)
    member = @team.team_members.find_by(slack_user_name: slack_user_name)
    member.slack_user_id = slack_user_id
    member.save!
    member
  end
end