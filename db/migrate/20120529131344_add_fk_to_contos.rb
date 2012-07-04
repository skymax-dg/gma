class AddFkToContos < ActiveRecord::Migration
  def up
    #add a foreign key
    execute <<-SQL
      ALTER TABLE contos
        ADD CONSTRAINT fk_contos_anagen_id_anagens
        FOREIGN KEY (anagen_id)
        REFERENCES anagens
    SQL
  end

  def down
    #drop a foreign key
    execute <<-SQL
      ALTER TABLE contos DROP CONSTRAINT fk_contos_anagen_id_anagens
    SQL
  end
end
