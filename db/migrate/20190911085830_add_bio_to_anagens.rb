class AddBioToAnagens < ActiveRecord::Migration
  def change
    add_column :anagens, :bio, :text
  end
end
