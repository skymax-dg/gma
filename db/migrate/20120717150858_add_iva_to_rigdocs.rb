class AddIvaToRigdocs < ActiveRecord::Migration
  def change
    add_column :rigdocs, :iva_id, :integer, :references => :iva, :null => false, :default => 1
  end
end
