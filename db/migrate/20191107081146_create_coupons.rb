class CreateCoupons < ActiveRecord::Migration
  def change
    create_table :coupons do |t|
      t.integer :anagen_id, index: true
      t.integer :state, default: 0, index: true
      t.decimal :value, default: 0.0
      t.decimal :perc, default: 0.0
      t.date :dt_start
      t.date :dt_end
      t.date :dt_use
      t.decimal :ord_min, default: 0.0

      t.timestamps
    end
  end
end
