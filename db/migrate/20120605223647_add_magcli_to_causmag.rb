class AddMagcliToCausmag < ActiveRecord::Migration
  def change
    add_column :causmags, :magcli, :string, :limit => 1, :default => "N"
  end
end
