module Command
  class GiveUpvote < Base
    attr_accessor :team_id
    attr_accessor :upvote_uuid
    attr_accessor :params

    validates :team_id, presence: true
    validates :upvote_uuid, presence: true
    validates :params, presence: true

    alias :aggregate_id :upvote_uuid
  end
end
