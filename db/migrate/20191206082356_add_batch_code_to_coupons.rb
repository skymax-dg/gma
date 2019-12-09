class AddBatchCodeToCoupons < ActiveRecord::Migration
  def change
    add_column :coupons, :batch_code, :string, limit: 20
  end
end
