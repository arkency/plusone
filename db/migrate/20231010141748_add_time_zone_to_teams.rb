class AddTimeZoneToTeams < ActiveRecord::Migration[7.0]
  def change
    add_column :teams, :time_zone, :string
  end
end
