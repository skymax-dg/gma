class Iva < ActiveRecord::Base
  has_many :articles
  has_many :rigdocs
  has_many :tesdocs
  attr_accessible :codice, :descriz, :desest, :aliq, :flese

  validates :codice, :descriz, :desest, :flese, :presence => true
  validates :descriz, :length => { :maximum => 50}
  validates :desest, :length => { :maximum => 150}
  validates :flese, :length => { :maximum => 1}

end
