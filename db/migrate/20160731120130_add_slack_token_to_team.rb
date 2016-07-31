class AddSlackTokenToTeam < ActiveRecord::Migration
  def change
    add_column :teams, :slack_token, :string
  end
end
