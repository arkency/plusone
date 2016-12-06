class RecipientsUpvote < ActiveRecord::Base
  belongs_to :upvote
  belongs_to :recipient, class_name: "TeamMember"
end
