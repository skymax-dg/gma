class AddSufPivaToPaeses < ActiveRecord::Migration
  def change
    add_column :paeses, :prepiva, :string, :limit => 2
    add_column :paeses, :codfis, :string, :limit => 4
  end
end
