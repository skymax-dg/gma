class AddFlagPrivacyToAnagens < ActiveRecord::Migration
  def change
    add_column :anagens, :fl1_consenso, :integer, default: 0
    add_column :anagens, :fl2_consenso, :integer, default: 0
    add_column :anagens, :dt_consenso, :date
    add_column :anagens, :fl_newsletter, :integer, default: 0
  end
end
