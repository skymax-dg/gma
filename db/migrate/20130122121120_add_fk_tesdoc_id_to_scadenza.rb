class AddFkTesdocIdToScadenza < ActiveRecord::Migration
  def up
    #add a foreign key
    execute <<-SQL
      ALTER TABLE scadenzas
        ADD CONSTRAINT fk_scadenzas_tesdoc_id_tesdocs
        FOREIGN KEY (tesdoc_id)
        REFERENCES tesdocs
    SQL
  end
  def down
    #drop a foreign key
    execute <<-SQL
      ALTER TABLE scadenzas DROP CONSTRAINT fk_scadenzas_tesdoc_id_tesdocs
    SQL
  end
end
