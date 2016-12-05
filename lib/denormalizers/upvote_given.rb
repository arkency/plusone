module Denormalizers
  class UpvoteGiven
    def call(event)
      return if Upvote.find_by(uid: event.data[:upvote_uid]).present?
      Upvote.create(uid: event.data[:upvote_uid],
                    recipient_id: event.data[:recipient_id],
                    sender_id: event.data[:sender_id])
    end
  end
end
