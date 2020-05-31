class CreateAliases < ActiveRecord::Migration[6.0]
  def change
    create_table :aliases do |t|
      t.string :username
      t.string :user_alias

      t.timestamps
    end
  end
end
