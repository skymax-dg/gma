class AddFkToLocalitas < ActiveRecord::Migration
  def up
    #add a foreign key
    execute <<-SQL
      ALTER TABLE localitas
        ADD CONSTRAINT fk_localitas_paese_id_paeses
        FOREIGN KEY (paese_id)
        REFERENCES paeses
    SQL
  end

  def down
    #drop a foreign key
    execute <<-SQL
      ALTER TABLE localitas DROP CONSTRAINT fk_localitas_paese_id_paeses
    SQL
  end
end
