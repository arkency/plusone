class GiveUpvote
  CannotUpvoteYourself = Class.new(StandardError)

  def initialize
    @slack_adapter = SlackAdapter.new
    @event_store = Rails.configuration.event_store
  end

  def call(user_name, text, trigger_word, team)
    ActiveRecord::Base.transaction do
      sender = team.register_member(user_name)
      recipient =
        PrepareRecipient.new(@slack_adapter).call(team, text, trigger_word)
      upvote = recipient.receive_upvote(sender)
      publish_upvote_received(upvote)
      [recipient, sender]
    end
  end

  private

  def publish_upvote_received(upvote)
    @event_store.publish(
      upvote_received(upvote.recipient, upvote.sender),
      stream_name: "Upvote$#{upvote.id}",
      expected_version: :none
    )
  end

  def upvote_received(recipient, sender)
    UpvoteReceivedV2.new(
      data: {
        recipient_id: recipient.id,
        sender_id: sender.id,
        team_id: sender.team_id
      }
    )
  end
end
