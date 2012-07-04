class AddFkToCausmags < ActiveRecord::Migration
  def up
    #add a foreign key
    execute <<-SQL
      ALTER TABLE causmags
        ADD CONSTRAINT fk_causmags_magsrc_id_mags
        FOREIGN KEY (magsrc_id)
        REFERENCES mags
    SQL
    #add a foreign key
    execute <<-SQL
      ALTER TABLE causmags
        ADD CONSTRAINT fk_causmags_magdst_id_mags
        FOREIGN KEY (magdst_id)
        REFERENCES mags
    SQL
  end

  def down
    #drop a foreign key
    execute <<-SQL
      ALTER TABLE causmags DROP CONSTRAINT fk_causmags_magsrc_id_mags
    SQL
    #drop a foreign key
    execute <<-SQL
      ALTER TABLE causmags DROP CONSTRAINT fk_causmags_magdst_id_mags
    SQL
  end
end
