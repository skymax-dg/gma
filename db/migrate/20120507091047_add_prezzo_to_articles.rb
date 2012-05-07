class AddPrezzoToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :prezzo, :decimal, :precision => 8, :scale => 2, :default => 0
  end
end
