class AddFkTesdocIdToCosto < ActiveRecord::Migration
  def up
    #add a foreign key
    execute <<-SQL
      ALTER TABLE costos
        ADD CONSTRAINT fk_costos_tesdoc_id_tesdocs
        FOREIGN KEY (tesdoc_id)
        REFERENCES tesdocs
    SQL
  end
  def down
    #drop a foreign key
    execute <<-SQL
      ALTER TABLE costos DROP CONSTRAINT fk_costos_tesdoc_id_tesdocs
    SQL
  end
end
