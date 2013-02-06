class CreateConfs < ActiveRecord::Migration
  def change
    create_table :confs do |t|
      t.string :codice, :limit=>20, :null=>false
      t.string :descriz, :limit=>100
      t.string :insana, :limit=>1, :null=>false
      t.string :insind, :limit=>1, :null=>false
      t.string :insart, :limit=>1, :null=>false
      t.string :coderigdoc, :limit=>1, :null=>false
      t.string :defcaustra, :limit=>3
      t.string :defcorriere, :limit=>3
      t.string :defaspetto, :limit=>3
      t.integer :defnrcolli
      t.string :defum, :limit=>2
      t.decimal :defvalore, :precision => 8, :scale => 2
      t.string :defporto, :limit=>3
      t.date :defdtrit
      t.time :deforarit
      t.string :defnote, :limit=>1000
      t.string :defpagam, :limit=>500
      t.string :defbanca, :limit=>200

      t.timestamps
    end
  end
end
