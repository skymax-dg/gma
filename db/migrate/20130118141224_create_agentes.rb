class CreateAgentes < ActiveRecord::Migration
  def change
    create_table :agentes do |t|
      t.integer :anagen_id
      t.decimal :provv, :precision => 5, :scale => 2, :null => false

      t.timestamps
    end
  end
end
