class CreateContos < ActiveRecord::Migration
  def change
    create_table :contos do |t|
      t.integer :azienda, :null => false
      t.integer :annoese, :null => false
      t.integer :codice, :null => false
      t.string :descriz, :limit => 150, :null => false
      t.string :tipoconto, :limit => 1, :null => false
      t.integer :cntrpartita
      t.decimal :sconto, :precision => 5, :scale => 2, :default => 0, :null => false

      t.timestamps
    end
  add_index "contos", ["azienda", "annoese", "codice"], {:name => "idx_contos_on_codice", :unique => true}
  add_index "contos", ["azienda", "annoese", "descriz"], {:name => "idx_contos_on_descriz", :unique => false}
  end
end
