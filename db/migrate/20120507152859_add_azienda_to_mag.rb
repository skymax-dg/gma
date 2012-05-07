class AddAziendaToMag < ActiveRecord::Migration
  def change
    add_column :mags, :azienda, :integer, :null => false
  end
end
