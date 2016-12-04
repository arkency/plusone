class AddUidToUpvotes < ActiveRecord::Migration
  def change
    add_column :upvotes, :uid, :string
  end
end
