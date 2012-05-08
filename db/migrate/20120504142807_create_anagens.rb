class CreateAnagens < ActiveRecord::Migration
  def change
    create_table :anagens do |t|
      t.integer :azienda, :null => false
      t.integer :codice, :null => false
      t.string :tipo, :limit => 1, :null => false
      t.string :cognome, :limit => 100
      t.string :nome, :limit => 100
      t.string :ragsoc, :limit => 150
      t.string :codfis, :limit => 16
      t.string :pariva, :limit => 11
      t.decimal :sconto, :precision => 5, :scale => 2, :default => 0, :null => false

      t.timestamps
    end
    add_index :anagens, [:azienda, :codice], {:name => "idx_anagens_on_codice", :unique => true}
    add_index :anagens, [:azienda, :codfis], {:name => "idx_anagens_on_codfis", :unique => true}
    add_index :anagens, [:azienda, :pariva], {:name => "idx_anagens_on_pariva", :unique => true}
    add_index :anagens, [:azienda, :cognome, :nome], {:name => "idx_anagens_on_cognome-nome"}
    add_index :anagens, [:azienda, :ragsoc], {:name => "idx_anagens_on_ragsoc"}
  end
end
