class Iva < ActiveRecord::Base
  has_many :rigdocs
  has_many :tesdocs
  attr_accessible :codice, :descriz, :desest, :aliq, :flese

  validates :codice, :descriz, :desest, :flese, :presence => true
#  validates :descriz, :length => { :maximum => 50}
#  validates :cap, :length => { :maximum => 5}
#  validates :codfis, :length => { :maximum => 4}
#  validates :prov, :length => { :maximum => 2}

end
