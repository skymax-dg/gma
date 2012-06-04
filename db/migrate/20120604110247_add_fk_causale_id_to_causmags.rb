class AddFkCausaleIdToCausmags < ActiveRecord::Migration
  def up
    add_column :causmags, :causale_id, :integer, :references => :causale
    #add a foreign key
    execute <<-SQL
      ALTER TABLE causmags
        ADD CONSTRAINT fk_causmags_causale_id_causales
        FOREIGN KEY (causale_id)
        REFERENCES causales
    SQL
  end

  def down
    #drop a foreign key
    execute <<-SQL
      ALTER TABLE causmags DROP CONSTRAINT fk_causmags_causale_id_causales
    SQL
    remove_column :causmags, :causale_id
  end
end
