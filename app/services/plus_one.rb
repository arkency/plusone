class PlusOne
  class CannotPlusOneYourself < StandardError; end
  class InvalidSlackToken < StandardError; end

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

      team = Team.find_by(slack_team_id: team_params[:team_id])

      sender = PrepareSender.new(team).call(params)
      recipient = PrepareRecipient.new(team, SlackAdapter.new(team.slack_token)).call(params)

      recipient_name = MessageParser.new(params[:text], params[:trigger_word]).recipient_name
      if Alias.exists?(user_alias: recipient_name)
        recipient = team.team_members.find_by(slack_user_name: Alias.find_by(user_alias: recipient_name).username)
      end
      raise InvalidSlackToken if user_tag_which_is_not_an_alias?(recipient, recipient_name)
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

  def user_tag_which_is_not_an_alias?(recipient, recipient_name)
    (recipient.slack_user_name == 'u') && ! Alias.exists?(user_alias: recipient_name)
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
