class ChangePublickkeytoBinary < ActiveRecord::Migration
  def change
  	remove_column :users, :public_key, :string
    add_column :users, :public_key, :binary
  end
end
