class AddIndexToUsers < ActiveRecord::Migration[5.0]
  def change
    add_index :users, :avatar_id
    add_index :users, :cover_image_id
  end
end
