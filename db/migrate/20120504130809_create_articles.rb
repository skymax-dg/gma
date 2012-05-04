class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :codice
      t.string :descriz

      t.timestamps
    end
    add_index :articles, :codice, {:name => "idx_articles_on_codice", :unique => true}
    add_index :articles, :descriz, {:name => "idx_articles_on_descriz", :unique => true}
  end
end
