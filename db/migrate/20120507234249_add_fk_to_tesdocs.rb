class AddFkToTesdocs < ActiveRecord::Migration
  def up
    #add a foreign key
    execute <<-SQL
      ALTER TABLE tesdocs
        ADD CONSTRAINT fk_tesdocs_causmag_id_causmags
        FOREIGN KEY (causmag_id)
        REFERENCES causmags
    SQL
    #add a foreign key
    execute <<-SQL
      ALTER TABLE tesdocs
        ADD CONSTRAINT fk_tesdocs_conto_id_contos
        FOREIGN KEY (conto_id)
        REFERENCES contos
    SQL
  end

  def down
    #drop a foreign key
    execute <<-SQL
      ALTER TABLE tesdocs DROP CONSTRAINT fk_tesdocs_causmag_id_causmags
    SQL
    #drop a foreign key
    execute <<-SQL
      ALTER TABLE tesdocs DROP CONSTRAINT fk_tesdocs_conto_id_contos
    SQL
  end
end
