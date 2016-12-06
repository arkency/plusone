class CreateRecipientsUpvotes < ActiveRecord::Migration
  def change
    create_table :recipients_upvotes do |t|
      t.integer :recipient_id
      t.integer :upvote_id
    end
    add_index :recipients_upvotes, :recipient_id
    add_index :recipients_upvotes, :upvote_id
  end
end
