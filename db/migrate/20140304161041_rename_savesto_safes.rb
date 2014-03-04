class RenameSavestoSafes < ActiveRecord::Migration
  def change
    def self.up
        rename_table :saves, :safes
    end 
    def self.down
        rename_table :safes, :saves
    end
 end
end
