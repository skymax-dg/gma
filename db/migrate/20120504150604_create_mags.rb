class CreateMags < ActiveRecord::Migration
  def change
    create_table :mags do |t|
      t.integer :azienda, :null => false
      t.integer :codice, :null => false
      t.string :descriz, :null => false

      t.timestamps
    end
    add_index :mags, [:azienda, :codice], {:name => "idx_mags_on_codice", :unique => true}
    add_index :mags, [:azienda, :descriz], {:name => "idx_mags_on_descriz", :unique => true}
  end
end
