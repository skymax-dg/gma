class DropMags < ActiveRecord::Migration
  def up
    drop_table :mags
  end

  def down
    create_table :mags do |t|
      t.integer :azienda, :null => false
      t.integer :codice, :null => false
      t.string :descriz, :limit => 50, :null => false

      t.timestamps
    end
  end
end
