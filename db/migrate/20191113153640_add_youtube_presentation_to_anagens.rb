class AddYoutubePresentationToAnagens < ActiveRecord::Migration
  def change
    add_column :anagens, :youtube_presentation, :string, limit: 50
  end
end
