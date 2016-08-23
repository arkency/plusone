class TeamMember < ActiveRecord::Base
	has_many :upvotes, class_name: 'Upvote', foreign_key: 'recipient_id'
	has_many :given_upvotes, class_name: 'Upvote', foreign_key: 'sender_id'
end
