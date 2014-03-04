class ChangeRawfiletoString < ActiveRecord::Migration
  def change
    remove_column :safes, :rawfile, :binary
    add_column :safes, :rawfile, :string
  end
end
