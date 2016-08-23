class Upvote < ActiveRecord::Base
  belongs_to :sender, class_name: "TeamMember"
  belongs_to :recipient, class_name: "TeamMember"
end
