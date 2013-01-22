class CreateCostos < ActiveRecord::Migration
  def change
    create_table :costos do |t|
      t.integer :tesdoc_id, :null=>false
      t.date :data
      t.string :tipo_spe, :limit=>2, :null=>false
      t.string :stato, :limit=>2, :null=>false
      t.string :descriz, :limit => 100
      t.decimal :importo, :precision => 8, :scale => 2, :default => 0, :null => false

      t.timestamps
    end
    add_index "costos", ["tesdoc_id"], :name => "index_costos_on_tesdoc_id"
    add_index "costos", ["data"], :name => "index_costos_on_data"
  end
end
