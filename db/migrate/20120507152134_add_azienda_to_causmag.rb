class AddAziendaToCausmag < ActiveRecord::Migration
  def change
    add_column :causmags, :azienda, :integer, :null => false
  end
end
