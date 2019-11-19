class AddCodeToCoupons < ActiveRecord::Migration
  def change
    add_column :coupons, :code, :string, limit: 30, index: true
  end
end
