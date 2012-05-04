class CreateAnagens < ActiveRecord::Migration
  def change
    create_table :anagens do |t|
      t.integer :codice
      t.string :tipo
      t.string :cognome
      t.string :nome
      t.string :ragsoc
      t.string :codfis
      t.string :pariva

      t.timestamps
    end
    add_index :anagens, :codice, {:name => "idx_anagens_on_codice", :unique => true}
    add_index :anagens, :codfis, {:name => "idx_anagens_on_codfis", :unique => true}
    add_index :anagens, :pariva, {:name => "idx_anagens_on_pariva", :unique => true}
  end
end
