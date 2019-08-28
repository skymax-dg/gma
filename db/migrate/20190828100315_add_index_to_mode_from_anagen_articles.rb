class AddIndexToModeFromAnagenArticles < ActiveRecord::Migration
  def change
    add_index :anagen_articles, :mode
  end
end
