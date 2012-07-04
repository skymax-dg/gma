class AddFkToArticles < ActiveRecord::Migration
  def up
    #add a foreign key
    execute <<-SQL
      ALTER TABLE rigdocs
        ADD CONSTRAINT fk_rigdocs_article_id_articles
        FOREIGN KEY (article_id)
        REFERENCES articles
    SQL
  end

  def down
    #drop a foreign key
    execute <<-SQL
      ALTER TABLE rigdocs DROP CONSTRAINT fk_rigdocs_article_id_articles
    SQL
  end
end
