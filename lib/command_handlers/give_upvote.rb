module CommandHandlers
  class GiveUpvote < Command::Handler
    def call(command)
      with_aggregate(command.aggregate_id) do |upvote|
        upvote.give(command.team_id, command.params)
      end
    end

    private

    def aggregate_class
      Domain::Upvote
    end
  end
end
