module Domain
  class Upvote
    include AggregateRoot
    class AlreadyGiven < StandardError; end

    def initialize(uid = generate_uuid)
      @uid = uid
      @state = :new
    end

    def give(team_id, params)
      raise AlreadyGiven if state == :given
      apply Events::UpvoteGiven.new(data: {upvote_uid: uid, team_id: team_id, params: params})
    end

    private
    attr_reader :state, :uid

    def apply_upvote_given(param)
      @state = :given
    end
  end
end
