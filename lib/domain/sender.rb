module Domain
  class Sender
    include AggregateRoot
    class CannotUpvoteYourself < StandardError; end
    class InvalidSlackToken < StandardError; end

    def initialize(uid = generate_uuid)
      @uid = uid
    end

    def give_upvote(team_id, params)
      team = Team.find(team_id)
      sender, recipient = prepare_transaction_actors(team).call(params)
      raise InvalidSlackToken if recipient.slack_user_name == 'u'
      raise CannotUpvoteYourself if sender == recipient
      apply Events::UpvoteGiven.new(data: {upvote_uid: uid, sender_id: sender.id, recipient_id: recipient.id})
    end

    private
    attr_reader :uid

    def prepare_transaction_actors(team)
      PrepareTransactionActors.new(team, SlackAdapter.new(team.slack_token))
    end

    def apply_upvote_given(event)
      TeamMember.find(event.data[:recipient_id]).increment!(:points)
    end
  end
end
