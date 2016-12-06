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
      recipients_ids = recipients.map(&:id)
      recipients_ids.delete(sender.id)
      raise InvalidSlackToken if recipients.any? { |rc| rc.slack_user_name == 'u' }
      raise CannotUpvoteYourself if recipients_ids.empty?
      apply Events::UpvoteGiven.new(data: {upvote_uuid: uuid, sender_id: sender.id, recipients_ids: recipients_ids})
    end

    private
    attr_reader :uuid

    def prepare_transaction_actors(team)
      PrepareTransactionActors.new(team, SlackAdapter.new(team.slack_token))
    end

    def apply_upvote_given(event)
      TeamMember.where(id: event.data[:recipients_ids]).each do |tm|
        tm.increment!(:points)
      end
    end
  end
end
