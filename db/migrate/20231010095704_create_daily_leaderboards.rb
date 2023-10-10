class CreateDailyLeaderboards < ActiveRecord::Migration[7.0]
  def change
    create_table :daily_leaderboard do |t|
      t.string :user_name
      t.date :date
      t.integer :points, default: 0

      t.timestamps
    end

    add_index :daily_leaderboard, [:date, :user_name], unique: true
  end
end
