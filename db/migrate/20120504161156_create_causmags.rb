class CreateCausmags < ActiveRecord::Migration
  def change
    create_table :causmags do |t|
      t.string :descriz
      t.string :tipo
      t.references :magsrc
      t.references :magdst
      t.string :contabile

      t.timestamps
    end
    add_index :causmags, :magsrc_id
    add_index :causmags, :magdst_id
  end
end
