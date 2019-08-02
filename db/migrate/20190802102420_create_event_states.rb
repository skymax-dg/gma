class CreateEventStates < ActiveRecord::Migration
  def change
    create_table :event_states do |t|
      t.references :event
      t.references :anagen
      t.integer :mode

      t.timestamps
    end
  end
end
