class TeamMember < ActiveRecord::Base
  self.ignored_columns = [:slack_user_id]

  has_many :upvotes, class_name: "Upvote", foreign_key: "recipient_id"
  has_many :given_upvotes, class_name: "Upvote", foreign_key: "sender_id"

  def receive_upvote(sender)
    raise GiveUpvote::CannotUpvoteYourself if sender.eql?(self)

    increment!(:points)
    Upvote.create(recipient: self, sender: sender)
  end
end
