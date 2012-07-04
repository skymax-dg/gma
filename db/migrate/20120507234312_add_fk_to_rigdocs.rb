class AddFkToRigdocs < ActiveRecord::Migration
  def up
    #add a foreign key
    execute <<-SQL
      ALTER TABLE rigdocs
        ADD CONSTRAINT fk_rigdocs_tesdoc_id_tesdocs
        FOREIGN KEY (tesdoc_id)
        REFERENCES tesdocs
    SQL
  end
  def down
    #drop a foreign key
    execute <<-SQL
      ALTER TABLE rigdocs DROP CONSTRAINT fk_rigdocs_tesdoc_id_tesdocs
    SQL
  end
end
