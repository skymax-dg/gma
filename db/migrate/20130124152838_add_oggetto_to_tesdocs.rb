class AddOggettoToTesdocs < ActiveRecord::Migration
  def change
    add_column :tesdocs, :oggetto, :string, :limit => 150
  end
end
