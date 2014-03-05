class AddUserIdToSafes < ActiveRecord::Migration
  def change
  	add_column :safes, :user_id, :integer
  end
end
