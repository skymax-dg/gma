class CreateContos < ActiveRecord::Migration
  def change
    create_table :contos do |t|
      t.integer :azienda, :null => false
      t.integer :annoese, :null => false
      t.integer :codice, :null => false
      t.string :descriz, :null => false
      t.string :tipoconto, :null => false
      t.integer :cntrpartita

      t.timestamps
    end
  add_index "contos", ["azienda", "annoese", "codice"], :name => "idx_contos_on_azienda-annoese-codice", :unique => true
  add_index "contos", ["descriz"], :name => "idx_contos_on_descriz", :unique => false
  end
end
