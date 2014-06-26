class Changekeytobinary < ActiveRecord::Migration
  def change
    remove_column :keys, :public, :string
    add_column :users, :public, :binary
  end
end
