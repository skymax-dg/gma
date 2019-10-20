class ExpandYoutubePresentationToArticles < ActiveRecord::Migration
  def change
    change_column :articles, :youtube_presentation, :string, limit: 50
  end
end
