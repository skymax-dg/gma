class Prezzoarticcli < ActiveRecord::Base
  belongs_to :anag, :class_name => "Conto"
  belongs_to :artic, :class_name => "Article"
  attr_accessible :prezzo, :anag_id, :artic_id

  validates :prezzo, :anag_id, :artic_id, :presence => true
end
