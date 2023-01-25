class GiveUpvote
  CannotUpvoteYourself = Class.new(StandardError)

  def initialize
    @slack_adapter = SlackAdapter.new
  end

  def call(user_name, text, trigger_word, team)
    ActiveRecord::Base.transaction do
      sender = team.register_member(user_name)
      recipient =
        PrepareRecipient.new(@slack_adapter).call(team, text, trigger_word)
      recipient.receive_upvote(sender)
      [recipient, sender]
    end
  end
end
