class AddDatesToEvents < ActiveRecord::Migration
  def change
    add_column :events, :dt_event2, :date
    add_column :events, :dt_event3, :date
    add_column :events, :dt_event4, :date
  end
end
