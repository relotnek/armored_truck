class ChangePrivkeytoBinary < ActiveRecord::Migration
  def change
  	remove_column :users, :priv_key, :string
    add_column :users, :priv_key, :binary
  end
end
