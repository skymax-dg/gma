class AddFkToArticlesVsIva < ActiveRecord::Migration
  def up
    #add a foreign key
    execute <<-SQL
      ALTER TABLE articles
		ADD CONSTRAINT fk_articles_iva_id_ivas
        FOREIGN KEY (iva_id)
        REFERENCES ivas
    SQL
  end

  def down
    #drop a foreign key
    execute <<-SQL
      ALTER TABLE articles DROP CONSTRAINT fk_articles_iva_id_ivas
    SQL
  end
end
