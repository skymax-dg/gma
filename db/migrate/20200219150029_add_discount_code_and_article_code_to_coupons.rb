class AddDiscountCodeAndArticleCodeToCoupons < ActiveRecord::Migration
  def change
    add_column :coupons, :discount_code, :string, limit: 30, index: true
    add_column :coupons, :article_id, :integer, index: true
  end
end
