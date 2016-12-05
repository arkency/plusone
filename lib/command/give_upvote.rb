module Command
  class GiveUpvote < Base
    attr_accessor :team_id
    attr_accessor :upvote_uid
    attr_accessor :params

    validates :team_id, presence: true
    validates :upvote_uid, presence: true
    validates :params, presence: true

    alias :aggregate_id :upvote_uid
  end
end
