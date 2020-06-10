class PrepareSender
  class MissingRecipient < StandardError ; end

  def initialize(team)
    @team = team
  end

  def call(params)
    member = @team.team_members.find_or_initialize_by(slack_user_name: params[:user_name])
    member.slack_user_id = params[:user_id]
    member.save!
    member
  end
end
