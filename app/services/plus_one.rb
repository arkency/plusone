class PlusOne
  class CannotPlusOneYourself < StandardError; end

  class SlackTeam
    attr_reader :id, :domain

    def initialize(id, domain)
      @id     = id
      @domain = domain
    end
  end

  def call(params, team_params)
    ActiveRecord::Base.transaction do
      register_team_if_needed(team_params)
      register_sender_if_needed(team_params[:team_id], params[:user_name], params[:user_id])

      team = Team.find_by(slack_team_id: team_params[:team_id])
      sender = PrepareSender.new(team).call(params[:user_name], params[:user_id])
      recipient = PrepareRecipient.new(team, SlackAdapter.new(team.slack_token)).call(params)

      raise CannotPlusOneYourself if sender == recipient

      recipient.increment!(:points)
      Upvote.create(recipient: recipient, sender: sender)

      return slack_output_message(recipient, sender)
    end
  end

  private

  def slack_output_message(recipient, sender)
    {
      text: "#{sender.slack_user_name}(#{sender.points}) gave +1 for #{recipient.slack_user_name}(#{recipient.points})",
      parse: "none"
    }
  end

  def register_team_if_needed(team_params)
    slack_team = slack_team(team_params)
    register_team(slack_team) unless team_exists?(slack_team)
  end

  def register_sender_if_needed(team_id, user_name, slack_user_id)
    register_team_member(user_name, slack_user_id, team_id) unless Team.find_by(slack_team_id: team_id).team_members.exists?(slack_user_name: user_name)
  end

  def register_team_member(user_name, slack_user_id, team_id)
    RegisterTeamMember.new.call(team_id, user_name, slack_user_id)
  end

  def slack_team(team_params)
    SlackTeam.new(team_params[:team_id], team_params[:team_domain])
  end

  def team_exists?(slack_team)
    Team.exists?(slack_team_id: slack_team.id)
  end

  def register_team(slack_team)
    Team.create!(slack_team_id: slack_team.id, slack_team_domain: slack_team.domain)
  end
end
