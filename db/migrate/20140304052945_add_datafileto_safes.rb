class AddDatafiletoSafes < ActiveRecord::Migration
  def change
    add_column :saves, :rawfile, :binary
  end
end
