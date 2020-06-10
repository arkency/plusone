class PrepareSender
  class MissingRecipient < StandardError ; end

  def initialize(team)
    @team = team
  end

  def call(slack_user_name, slack_user_id)
    member = @team.team_members.find_or_initialize_by(slack_user_name: slack_user_name)
    member.slack_user_id = slack_user_id
    member.save!
    member
  end
end
