class Rigdoc < ActiveRecord::Base
  belongs_to :article
  belongs_to :tesdoc

  #scope :order, :qta
  default_scope :order => 'rigdocs.prgrig ASC'
  
  attr_accessible :descriz, :prezzo, :qta, :sconto, :article_id, :tesdoc_id
end
