class CreateAnagSocials < ActiveRecord::Migration
  def change
    create_table :anag_socials do |t|
      t.integer :anagen_id, index: true
      t.string :stype, limit: 4
      t.string :saddr, limit: 50
      t.integer :state, default: 1

      t.timestamps
    end
  end
end
