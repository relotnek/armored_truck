class RemoveExtraFieldsFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :public
    remove_column :users, :priv_key
    remove_column :users, :public_key
  end
end
