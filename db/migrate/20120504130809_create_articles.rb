class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.integer :azienda, :null => false
      t.string  :codice, :limit => 20, :null => false
      t.string  :descriz, :limit => 100, :null => false
      t.decimal :prezzo, :precision => 8, :scale => 2, :default => 0, :null => false

      t.timestamps
    end
    add_index :articles, [:azienda, :codice], {:name => "idx_articles_on_codice", :unique => true}
    add_index :articles, [:azienda, :descriz], {:name => "idx_articles_on_descriz", :unique => true}
  end
end
