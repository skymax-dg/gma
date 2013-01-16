class CreateScadenzas < ActiveRecord::Migration
  def change
    create_table :scadenzas do |t|
      t.integer :tesdoc_id, :null=>false
      t.date :data
      t.string :tipo, :limit=>2, :null=>false
      t.string :stato, :limit=>1, :null=>false
      t.string :descriz, :limit => 100

      t.timestamps
    end
    add_index "scadenzas", ["tesdoc_id"], :name => "index_scadenzas_on_tesdoc_id"
    add_index "scadenzas", ["data"], :name => "index_scadenzas_on_data"
  end
end
