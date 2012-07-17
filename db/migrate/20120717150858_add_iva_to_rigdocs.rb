class AddIvaToRigdocs < ActiveRecord::Migration
  def change
    add_column :rigdocs, :iva_id, :integer, :references => :iva
  end
end
