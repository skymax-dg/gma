class CreatePaeses < ActiveRecord::Migration
  def change
    create_table :paeses do |t|
      t.string :descriz, :limit => 50, :null => false
      t.string :tpeu, :limit => 1, :null => false

      t.timestamps
    end
    add_index :paeses, [:descriz], {:name => "idx_paeses_on_descriz", :unique => true}
  end
end
