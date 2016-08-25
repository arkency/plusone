class RenamePlusesToUpvotes < ActiveRecord::Migration
  def change
    rename_table :pluses, :upvotes
  end
end
