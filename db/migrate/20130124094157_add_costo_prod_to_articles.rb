class AddCostoProdToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :costo, :decimal, :precision => 8, :scale => 2, :default => 0, :null => false
  end
end
