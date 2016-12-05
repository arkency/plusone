class AddUuidToUpvotes < ActiveRecord::Migration
  def change
    add_column :upvotes, :uuid, :string
    add_index :upvotes, :uuid
  end
end
