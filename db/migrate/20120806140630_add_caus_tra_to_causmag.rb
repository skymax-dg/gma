class AddCausTraToCausmag < ActiveRecord::Migration
  def change
    add_column :causmags, :caus_tra, :string, :limit => 50
  end
end
