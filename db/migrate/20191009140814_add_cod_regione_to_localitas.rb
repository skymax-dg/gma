class AddCodRegioneToLocalitas < ActiveRecord::Migration
  def change
    add_column :localitas, :cod_regione, :integer, index: true
  end
end
