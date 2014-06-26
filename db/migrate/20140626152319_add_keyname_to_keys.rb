class AddKeynameToKeys < ActiveRecord::Migration
  def change
    add_column :keys, :name, :string
  end
end
