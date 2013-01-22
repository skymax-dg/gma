class AddFkAgenteIdToTesdoc < ActiveRecord::Migration
  def up
    #add a foreign key
    execute <<-SQL
      ALTER TABLE tesdocs
        ADD CONSTRAINT fk_tesdocs_agente_id_agentes
        FOREIGN KEY (agente_id)
        REFERENCES agentes
    SQL
  end

  def down
    #drop a foreign key
    execute <<-SQL
      ALTER TABLE tesdocs DROP CONSTRAINT fk_tesdocs_agente_id_agentes
    SQL
  end
end
