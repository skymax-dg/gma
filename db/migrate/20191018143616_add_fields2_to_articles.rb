class AddFields2ToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :translator, :string, limit: 30
    add_column :articles, :series, :string, limit: 30
    add_column :articles, :director_series, :string, limit: 30
    add_column :articles, :collaborator, :string, limit: 30
    add_column :articles, :youtube_presentation, :string, limit: 40
  end
end
