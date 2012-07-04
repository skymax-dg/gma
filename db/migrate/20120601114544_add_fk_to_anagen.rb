class AddFkToAnagen < ActiveRecord::Migration
  def up
    #add a foreign key
    execute <<-SQL
      ALTER TABLE anagens
        ADD CONSTRAINT fk_anagens_luogonas_id_localitas
        FOREIGN KEY (luogonas_id)
        REFERENCES localitas
    SQL
  end

  def down
    #drop a foreign key
    execute <<-SQL
      ALTER TABLE anagens DROP CONSTRAINT fk_anagens_luogonas_id_localitas
    SQL
  end
end
