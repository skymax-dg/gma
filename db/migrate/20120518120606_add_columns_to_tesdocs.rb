class AddColumnsToTesdocs < ActiveRecord::Migration
  def change
    add_column :tesdocs, :nrmagsrc, :integer, :null => false, :default => 0
    add_column :tesdocs, :nrmagdst, :integer, :null => false, :default => 0
    add_column :tesdocs, :seguefatt, :string, :limit => 1, :null => false, :default => 'N'
  end
end
