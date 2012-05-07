class AddMovImpMagToCausmag < ActiveRecord::Migration
  def change
    add_column :causmags, :movimpmag, :string, :limit => 1 
  end
end
