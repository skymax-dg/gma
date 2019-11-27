class ChangeFlagPrivacyToAnagens < ActiveRecord::Migration
  def change
    add_column :anagens, :dt_revoca_consenso, :date
    add_column :anagens, :fl3_consenso, :integer, default: 0
    add_column :anagens, :fl4_consenso, :integer, default: 0
    add_column :anagens, :fl5_consenso, :integer, default: 0
    add_column :anagens, :fl6_consenso, :integer, default: 0
    add_column :anagens, :stato_consenso, :integer, default: 0
  end
end
