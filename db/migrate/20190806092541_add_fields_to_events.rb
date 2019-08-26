class AddFieldsToEvents < ActiveRecord::Migration
  def change
    add_column :events, :timetable,      :string, limit: 20
    add_column :events, :dressing,       :text
    add_column :events, :duration,       :integer
    add_column :events, :quantity,       :integer
    add_column :events, :nr_item,        :integer
    add_column :events, :yr_item,        :integer
    add_column :events, :site_anagen_id, :integer 
    add_column :events, :state,          :integer
    add_column :events, :mode,           :integer
    add_column :events, :cut_off,        :integer
    add_column :events, :dt_event,       :date
    add_column :events, :dt_end_isc,     :date
    add_column :events, :dt_discount,    :date
    rename_column :events, :desc,    :description
  end
end
