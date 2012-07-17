class AddIvaToTesdocs < ActiveRecord::Migration
  def change
    add_column :tesdocs, :iva_id, :integer, :references => :iva
  end
end
