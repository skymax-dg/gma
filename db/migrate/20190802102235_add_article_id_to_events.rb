class AddArticleIdToEvents < ActiveRecord::Migration
  def change
    add_column :events, :article_id, :integer, index: true
  end
end
