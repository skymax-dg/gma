class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :type, limit: 24, index: true

      t.timestamps
    end
  end
end
