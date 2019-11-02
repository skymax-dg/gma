class AddPagineERilegaturaToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :pagine, :integer
    add_column :articles, :rilegatura, :integer
  end
end
