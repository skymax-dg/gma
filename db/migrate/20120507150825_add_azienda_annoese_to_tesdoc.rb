class AddAziendaAnnoeseToTesdoc < ActiveRecord::Migration
  def change
    add_column :tesdocs, :azienda, :integer, :null => false
    add_column :tesdocs, :annoese, :integer, :null => false
  end
end
