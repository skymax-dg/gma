class AddflagRemovetpindToAnaind < ActiveRecord::Migration
  def up
    remove_column :anainds, :tpind
    add_column :anainds, :flsl, :string, :limit => 1, :null => false, :default => "S"
    add_column :anainds, :flsp, :string, :limit => 1, :null => false, :default => "S"
    add_column :anainds, :flmg, :string, :limit => 1, :null => false, :default => "N"
  end

  def down
    add_column :anainds, :tpind, :limit => 2, :null => false, :default => "SL"
    remove_column :anainds, :flsl, :string, :limit => 1
    remove_column :anainds, :flsp, :string, :limit => 1
    remove_column :anainds, :flmg, :string, :limit => 1    
  end
end
