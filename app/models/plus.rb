class Plus < ActiveRecord::Base
  self.table_name = "pluses"
  belongs_to :sender, class_name: "TeamMember"
  belongs_to :recipient, class_name: "TeamMember"
end
