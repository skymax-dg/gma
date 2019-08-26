class AnagenArticle < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :anagen
  belongs_to :article
end
