class TeamMember < ActiveRecord::Base
  has_many :pluses, class_name: 'Plus', foreign_key: 'recipient_id'
  has_many :given_pluses, class_name: 'Plus', foreign_key: 'sender_id'
end
