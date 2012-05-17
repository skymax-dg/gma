class AddSufPivaToPaeses < ActiveRecord::Migration
  def change
    add_column :paeses, :prepiva, :string, :limit => 2
  end
end
