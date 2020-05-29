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
      sender, recipient = prepare_transaction_actors(team).call(params)
      raise InvalidSlackToken if recipient.slack_user_name == 'u'
      raise CannotPlusOneYourself if sender == recipient
      recipient.increment!(:points)
      Upvote.create(recipient: recipient, sender: sender)

      return {
        text: "#{sender.slack_user_name}(#{sender.points}) gave +1 for #{recipient.slack_user_name}(#{recipient.points})",
        parse: "none"
      }
    end
  end

  private

  def slack_team(team_params)
    SlackTeam.new(team_params[:team_id], team_params[:team_domain])
  end

  def team_exists?(slack_team)
    Team.exists?(slack_team_id: slack_team.id)
  end

  def register_team(slack_team)
    Team.create!(slack_team_id: slack_team.id, slack_team_domain: slack_team.domain)
  end

  def prepare_transaction_actors(team)
    PrepareTransactionActors.new(team, SlackAdapter.new(team.slack_token))
  end
end
