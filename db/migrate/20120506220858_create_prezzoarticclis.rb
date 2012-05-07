class CreatePrezzoarticclis < ActiveRecord::Migration
  def change
    create_table :prezzoarticclis do |t|
      t.references :anag
      t.references :artic
      t.float :prezzo

      t.timestamps
    end
    add_index :prezzoarticclis, :anag_id
    add_index :prezzoarticclis, :artic_id
  end
end
