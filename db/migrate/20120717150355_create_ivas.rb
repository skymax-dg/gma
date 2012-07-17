class CreateIvas < ActiveRecord::Migration
  def change
    create_table :ivas do |t|
      t.integer :codice, :null => false
      t.string :descriz, :limit => 50, :null => false
      t.string :desest, :limit => 150, :null => false
      t.float :aliq, :precision => 5, :scale => 2, :null => false
      t.string :flese, :limit => 1, :null => false
      t.timestamps
    end
  end
end
