class AddDatafiletoSafes < ActiveRecord::Migration
  def change
    add_column :safes, :rawfile, :binary
  end
end
