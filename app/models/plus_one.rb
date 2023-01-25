class PlusOne
  CannotPlusOneYourself = Class.new(StandardError)

  def initialize(slack_adapter = SlackAdapter.new)
    @slack_adapter = slack_adapter
  end

  def call(user_name, text, trigger_word, team_id, team_domain)
    ActiveRecord::Base.transaction do
      team = Team.register(team_id, team_domain)
      sender = team.register_member(user_name)
      recipient =
        PrepareRecipient.new(@slack_adapter).call(team_id, text, trigger_word)

      recipient.receive_upvote(sender)
      [recipient, sender]
    end
  end
end
