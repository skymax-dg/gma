class AddRemoveColumnToAnagen < ActiveRecord::Migration
  def up
    remove_index :anagens, {:name => "idx_anagens_on_codice", :unique => true}
    remove_index :anagens, {:name => "idx_anagens_on_codfis", :unique => true}
    remove_index :anagens, {:name => "idx_anagens_on_pariva", :unique => true}
    remove_index :anagens, {:name => "idx_anagens_on_cognome-nome"}
    remove_index :anagens, {:name => "idx_anagens_on_ragsoc"}

    remove_column :anagens, :azienda
    remove_column :anagens, :cognome
    remove_column :anagens, :nome
    remove_column :anagens, :ragsoc
    add_column :anagens, :denomin, :string, :limit => 150, :null => false
    add_column :anagens, :telefono, :string, :limit => 20
    add_column :anagens, :email, :string, :limit => 50
    add_column :anagens, :fax, :string, :limit => 20
    add_column :anagens, :web, :string, :limit => 50

    add_index :anagens, [:codice], {:name => "idx_anagens_on_codice", :unique => true}
    add_index :anagens, [:codfis], {:name => "idx_anagens_on_codfis", :unique => true}
    add_index :anagens, [:pariva], {:name => "idx_anagens_on_pariva", :unique => true}
    add_index :anagens, [:denomin], {:name => "idx_anagens_on_denomin"}

  end

  def down
    remove_index :anagens, {:name => "idx_anagens_on_codice", :unique => true}
    remove_index :anagens, {:name => "idx_anagens_on_codfis", :unique => true}
    remove_index :anagens, {:name => "idx_anagens_on_pariva", :unique => true}
    remove_index :anagens, {:name => "idx_anagens_on_denomin"}

    remove_column :anagens, :denomin
    remove_column :anagens, :telefono
    remove_column :anagens, :email, :string
    remove_column :anagens, :fax, :string
    remove_column :anagens, :web, :string
    add_column :anagens, :azienda, :integer, :null => false, :default => 0
    add_column :anagens, :cognome, :string, :limit => 100
    add_column :anagens, :nome, :string, :limit => 100
    add_column :anagens, :ragsoc, :string, :limit => 150

    add_index :anagens, [:azienda, :codice], {:name => "idx_anagens_on_codice", :unique => true}
    add_index :anagens, [:azienda, :codfis], {:name => "idx_anagens_on_codfis", :unique => true}
    add_index :anagens, [:azienda, :pariva], {:name => "idx_anagens_on_pariva", :unique => true}
    add_index :anagens, [:azienda, :cognome, :nome], {:name => "idx_anagens_on_cognome-nome"}
    add_index :anagens, [:azienda, :ragsoc], {:name => "idx_anagens_on_ragsoc"}
  end
end
