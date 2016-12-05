module CommandHandler
  class GiveUpvote < Base
    def call(command)
      with_aggregate(command.aggregate_id) do |sender|
        sender.give_upvote(command.team_id, command.params)
      end
    end

    private

    def aggregate_class
      Domain::Sender
    end
  end
end
