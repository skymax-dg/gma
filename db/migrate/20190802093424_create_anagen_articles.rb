class CreateAnagenArticles < ActiveRecord::Migration
  def change
    create_table :anagen_articles do |t|
      t.references :anagen
      t.references :article
      t.integer :mode, default: 0

      t.timestamps
    end
  end
end
