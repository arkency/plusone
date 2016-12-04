module Denormalizers
  class UpvoteGiven
    class CannotPlusOneYourself < StandardError; end
    class InvalidSlackToken < StandardError; end

    def call(event)
      return if Upvote.find_by(uid: event.data[:upvote_uid]).present?
      ActiveRecord::Base.transaction do
        team = Team.find(event.data[:team_id])
        sender, recipient = prepare_transaction_actors(team).call(event.data[:params])
        raise InvalidSlackToken if recipient.slack_user_name == 'u'
        raise CannotPlusOneYourself if sender == recipient
        recipient.increment!(:points)
        Upvote.create(uid: event.data[:upvote_uid], recipient: recipient, sender: sender)
      end
    end

    private

    def prepare_transaction_actors(team)
      PrepareTransactionActors.new(team, SlackAdapter.new(team.slack_token))
    end
  end
end
