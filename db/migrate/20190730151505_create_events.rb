class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :type, limit: 24, index: true
      t.string :desc, limit: 40

      t.timestamps
    end
  end
end
