class ExtendCapAndAddStateToAnaindsAndLocalitas < ActiveRecord::Migration
  def change
    change_column :anainds, :cap, :string, limit: 10
    change_column :localitas, :cap, :string, limit: 10
    add_column :localitas, :state, :string, limit: 30
  end
end
