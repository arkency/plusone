class Upvote < ActiveRecord::Base
  belongs_to :sender, class_name: "TeamMember"
  belongs_to :recipient, class_name: "TeamMember"

  has_many :recipients_upvotes
  has_many :recipients, through: :recipients_upvotes, class_name: 'TeamMember'
end
