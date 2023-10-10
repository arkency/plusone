class AddTeamIdToDailyLeaderboard < ActiveRecord::Migration[7.0]
  def change
    add_reference :daily_leaderboard, :team, null: false, foreign_key: true
    remove_index :daily_leaderboard, [:date, :user_name], unique: true
    add_index :daily_leaderboard, [:team_id, :date, :user_name], unique: true
  end
end
