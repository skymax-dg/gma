class AddAgenteIdToTesdocs < ActiveRecord::Migration
  def change
    add_column :tesdocs, :agente_id, :integer
  end
end
