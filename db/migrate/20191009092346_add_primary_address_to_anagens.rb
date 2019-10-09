class AddPrimaryAddressToAnagens < ActiveRecord::Migration
  def change
    add_column :anagens, :primary_address_id, :integer, index: true
  end
end
