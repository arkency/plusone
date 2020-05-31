class CreateTeams < ActiveRecord::Migration[4.2]
  def change
    create_table :teams do |t|
      t.string :slack_team_id,     null: false
      t.string :slack_team_domain, null: false

      t.timestamps
    end
  end
end
