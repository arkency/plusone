class RenamePlusesToUpvotes < ActiveRecord::Migration[4.2]
  def change
    rename_table :pluses, :upvotes
  end
end
