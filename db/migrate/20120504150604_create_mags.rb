class CreateMags < ActiveRecord::Migration
  def change
    create_table :mags do |t|
      t.integer :codice
      t.string :descriz

      t.timestamps
    end
  end
end
