class CreatePrezzoarticclis < ActiveRecord::Migration
  def change
    create_table :prezzoarticclis do |t|
      t.integer :azienda, :null => false
      t.references :anag
      t.references :artic
      t.decimal :prezzo, :scale => 2, :precision => 8, :null => false
      t.timestamps
    end
    add_index :prezzoarticclis, [:azienda, :anag_id]
    add_index :prezzoarticclis, [:azienda, :artic_id]
    add_index :prezzoarticclis, [:azienda, :anag_id, :artic_id], {:unique => true}
  end
end
