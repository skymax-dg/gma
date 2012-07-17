class AddFkToRigdocsTesdocsVsIva < ActiveRecord::Migration
  def up
    #add a foreign key
    execute <<-SQL
      ALTER TABLE rigdocs
		ADD CONSTRAINT fk_rigdocs_iva_id_ivas
        FOREIGN KEY (iva_id)
        REFERENCES ivas
    SQL
    #add a foreign key
    execute <<-SQL
      ALTER TABLE tesdocs
      	ADD CONSTRAINT fk_tesdocs_iva_id_ivas
        FOREIGN KEY (iva_id)
        REFERENCES ivas
    SQL
  end

  def down
    #add a foreign key
    execute <<-SQL
      ALTER TABLE rigdocs DROP CONSTRAINT fk_rigdocs_iva_id_ivas
    SQL
    #add a foreign key
    execute <<-SQL
      ALTER TABLE tesdocs DROP CONSTRAINT fk_tesdocs_iva_id_ivas
    SQL
  end
end
