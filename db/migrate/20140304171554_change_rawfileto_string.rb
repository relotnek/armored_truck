class ChangeRawfiletoString < ActiveRecord::Migration
  def change
    add_column :safes, :rawfile, :string
  end
end
