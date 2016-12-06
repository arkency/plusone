module Denormalizers
  class UpvoteGiven
    def call(event)
      return if Upvote.find_by(uuid: event.data[:upvote_uuid]).present?
      recipients = TeamMember.where(id: event.data[:recipients_ids])
      Upvote.create(uuid: event.data[:upvote_uuid],
                    recipients: recipients,
                    sender_id: event.data[:sender_id])
    end
  end
end
