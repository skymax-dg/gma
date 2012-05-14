class AddFkToAnainds < ActiveRecord::Migration
  def up
    #add a foreign key
    execute <<-SQL
      ALTER TABLE anainds
        ADD CONSTRAINT fk_anainds_anagen_id_anagens
        FOREIGN KEY (anagen_id)
        REFERENCES anagens
    SQL
  end
  def down
    #drop a foreign key
    execute <<-SQL
      ALTER TABLE anagens DROP CONSTRAINT fk_anainds_anagen_id_anagens
    SQL
  end
end
