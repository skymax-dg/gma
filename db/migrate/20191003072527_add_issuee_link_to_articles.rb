class AddIssueeLinkToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :issuee_link, :text
  end
end
