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
      slack_team = slack_team(team_params)

      register_team(slack_team) unless team_exists?(slack_team)

      team = Team.find_by(slack_team_id: team_params[:team_id])
      sender, recipient = PrepareTransactionActors.new(team, SlackAdapter.new(team.slack_token)).call(params)
      recipient_name = MessageParser.new(params[:text], params[:trigger_word]).recipient_name
      raise InvalidSlackToken if user_tag_which_is_not_an_alias?(recipient, recipient_name)
      raise CannotPlusOneYourself if sender == recipient

      if Alias.exists?(user_alias: recipient_name)
        recipient = team.team_members.find_by(slack_user_name: Alias.find_by(user_alias: recipient_name).username)
      end
      recipient.increment!(:points)
      Upvote.create(recipient: recipient, sender: sender)

      return {
        text: "#{sender.slack_user_name}(#{sender.points}) gave +1 for #{recipient.slack_user_name}(#{recipient.points})",
        parse: "none"
      }
    end
  end

  private

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
