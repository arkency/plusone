module Domain
  class Sender
    include AggregateRoot
    class CannotUpvoteYourself < StandardError; end
    class InvalidSlackToken < StandardError; end

    def initialize(uuid = generate_uuid)
      @uuid = uuid
    end

    def give_upvote(team_id, params)
      team = Team.find(team_id)
      sender, recipients = prepare_transaction_actors(team).call(params)
      recipient = recipients.first
      raise InvalidSlackToken if recipient.slack_user_name == 'u'
      raise CannotUpvoteYourself if sender == recipient
      apply Events::UpvoteGiven.new(data: {upvote_uuid: uuid, sender_id: sender.id, recipient_id: recipient.id})
    end

    private
    attr_reader :uuid

    def prepare_transaction_actors(team)
      PrepareTransactionActors.new(team, SlackAdapter.new(team.slack_token))
    end

    def apply_upvote_given(event)
      TeamMember.find(event.data[:recipient_id]).increment!(:points)
    end
  end
end
