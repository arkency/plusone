class AddSlackTokenToTeam < ActiveRecord::Migration[4.2]
  def change
    add_column :teams, :slack_token, :string
  end
end
