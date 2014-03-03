class AddPrivkeyToUsers < ActiveRecord::Migration
  def change
    add_column :users, :priv_key, :string
  end
end
