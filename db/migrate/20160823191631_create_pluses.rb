class CreatePluses < ActiveRecord::Migration[4.2]
  def change
    create_table :pluses do |t|
      t.references :sender, index: true
      t.references :recipient, index: true

      t.timestamps null: false
    end

    add_foreign_key :pluses, :team_members, column: :sender_id
    add_foreign_key :pluses, :team_members, column: :recipient_id
  end
end
