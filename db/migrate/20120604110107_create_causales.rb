class CreateCausales < ActiveRecord::Migration
  def change
    create_table :causales do |t|
      t.integer :azienda, :null => false
      t.string  :descriz, :limit => 100, :null => false
      t.string  :tipoiva, :limit => 1, :null => false
      t.string  :tiporeg, :limit => 1, :null => false
      t.integer :contoiva
      t.timestamps
    end
  end
end
