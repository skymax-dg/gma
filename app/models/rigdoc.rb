class Rigdoc < ActiveRecord::Base
  belongs_to :article
  belongs_to :tesdoc

  attr_accessible :descriz, :prezzo, :qta, :sconto, :article_id
end
