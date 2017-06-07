class AddIndexToFriendships < ActiveRecord::Migration[5.0]
  def change
    add_index :friendships, :friendable_id
    add_index :friendships, :friendable_type
  end
end
