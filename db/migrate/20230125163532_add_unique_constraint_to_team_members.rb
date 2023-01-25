class AddUniqueConstraintToTeamMembers < ActiveRecord::Migration[7.0]
  def change
    add_index :team_members, [:slack_user_name, :team_id], unique: true
  end
end
