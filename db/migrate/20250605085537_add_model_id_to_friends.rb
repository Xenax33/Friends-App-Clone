class AddModelIdToFriends < ActiveRecord::Migration[8.0]
  def change
    add_column :friends, :model_id, :integer
    add_index :friends, :model_id
  end
end
