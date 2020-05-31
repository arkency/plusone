class CreateTeamMembers < ActiveRecord::Migration[4.2]
  def change
    create_table :team_members do |t|
      t.integer :team_id, null: false
      t.string :slack_user_id, null: true
      t.string :slack_user_name, null: false
      t.integer :points, null: false, default: 0

      t.timestamps
    end
  end
end
