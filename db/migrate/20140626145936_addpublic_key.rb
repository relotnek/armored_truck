class AddpublicKey < ActiveRecord::Migration
  def change
    add_column :keys, :public_key, :binary
  end
end
