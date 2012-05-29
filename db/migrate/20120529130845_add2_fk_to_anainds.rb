class Add2FkToAnainds < ActiveRecord::Migration
  def up
    #add a foreign key
    execute <<-SQL
      ALTER TABLE anainds
        ADD CONSTRAINT fk_anainds_localita_id_localitas
        FOREIGN KEY (localita_id)
        REFERENCES localitas
    SQL
  end

  def down
    #drop a foreign key
    execute <<-SQL
      ALTER TABLE anainds DROP CONSTRAINT fk_anainds_localita_id_localitas
    SQL
  end
end
